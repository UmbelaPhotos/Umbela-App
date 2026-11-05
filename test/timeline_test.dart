import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:umbela_app/core/data/models.dart';
import 'package:umbela_app/core/data/repositories.dart';
import 'package:umbela_app/core/providers.dart';
import 'package:umbela_app/core/storage/timeline_cache.dart';
import 'package:umbela_app/core/timeline/timeline_controller.dart';
import 'package:umbela_app/core/utils/lifo_gate.dart';
import 'package:umbela_app/core/utils/priority_gate.dart';
import 'package:umbela_app/core/widgets/photo_grid.dart';
import 'package:umbela_app/core/widgets/photo_thumb.dart';
import 'package:umbela_app/features/timeline/presentation/timeline_layout.dart';
import 'package:umbela_app/features/timeline/presentation/timeline_view.dart';

/// 120 months (Nov 2016 .. Oct 2026), 500 photos each: 60,000 photos, served
/// like the real server (pages, keyed by month range).
class BigLibrary implements PhotoRepository {
  BigLibrary({this.perMonth = 500});

  final int perMonth;
  final pageRequests = <TimelineBucket>[];
  int bucketRequests = 0;
  bool offline = false;

  static const _first = 2016 * 12 + 10; // Nov 2016

  late final List<TimelineBucket> buckets = [
    for (var k = _first + 119; k >= _first; k--)
      TimelineBucket(
        year: k ~/ 12,
        month: k % 12 + 1,
        count: perMonth,
        from: DateTime(k ~/ 12, k % 12 + 1),
        to: DateTime(k ~/ 12, k % 12 + 2).subtract(const Duration(seconds: 1)),
      ),
  ];

  @override
  Future<List<TimelineBucket>> timelineBuckets() async {
    bucketRequests++;
    if (offline) throw StateError('offline');
    return buckets;
  }

  @override
  Future<TimelinePage> timelinePage({
    DateTime? from,
    DateTime? to,
    String cursor = '',
    int pageSize = 500,
  }) async {
    if (offline) throw StateError('offline');
    final b = buckets.firstWhere((b) => b.from == from);
    pageRequests.add(b);
    final start = cursor.isEmpty ? 0 : int.parse(cursor);
    final end = (start + pageSize).clamp(0, perMonth);
    return TimelinePage([
      for (var i = start; i < end; i++)
        Photo(
          id: 'm${b.key}-$i',
          takenAt: b.to.subtract(Duration(minutes: i)),
          blurhash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
          tall: i % 4 == 0,
          aspect: i % 4 == 0 ? 0.75 : 1.33,
        ),
    ], end < perMonth ? '$end' : '');
  }

  @override
  Future<Uint8List> thumbnail(String photoId) async => Uint8List(0);

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

ProviderContainer _container(BigLibrary repo, {bool signedIn = true}) {
  final c = ProviderContainer(
    overrides: [photoRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(c.dispose);
  if (signedIn) c.read(sessionTokenProvider.notifier).set('t');
  return c;
}

const _settle = Duration(milliseconds: 400);

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  group('controller', () {
    test('the month list covers 60,000 photos; none are fetched yet', () async {
      final repo = BigLibrary();
      final c = _container(repo);
      final s = await c.read(timelineProvider.future);
      expect(s.buckets.length, 120);
      expect(s.totalPhotos, 60000);
      expect(s.loadedPhotos, isEmpty);
      expect(repo.pageRequests, isEmpty);
    });

    test('a month loads only after it stays visible', () async {
      final repo = BigLibrary();
      final c = _container(repo);
      await c.read(timelineProvider.future);
      final t = c.read(timelineProvider.notifier);
      final key = repo.buckets.first.key;

      // Flinging past: seen and gone within the settle time.
      t.track(key, 1);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      t.track(key, -1);
      await Future<void>.delayed(_settle);
      expect(repo.pageRequests, isEmpty);

      t.track(key, 1);
      await Future<void>.delayed(_settle);
      final s = c.read(timelineProvider).value!;
      expect(s.month(key).photos.length, 500);
      expect(repo.pageRequests.length, 1);
      expect(s.totalPhotos, 60000);
    });

    test('jumping to 2016 loads that month, not the ones in between', () async {
      final repo = BigLibrary();
      final c = _container(repo);
      final s0 = await c.read(timelineProvider.future);
      final t = c.read(timelineProvider.notifier);
      final oldest = s0.buckets.last;
      t.track(oldest.key, 1);
      await Future<void>.delayed(_settle);
      expect(repo.pageRequests.map((b) => b.key), [oldest.key]);
      expect(
        c.read(timelineProvider).value!.month(oldest.key).photos.length,
        500,
      );
    });

    test('a month bigger than a page is fetched page after page', () async {
      final repo = BigLibrary(perMonth: 1300);
      final c = _container(repo);
      await c.read(timelineProvider.future);
      final t = c.read(timelineProvider.notifier);
      final key = repo.buckets.first.key;
      t.track(key, 1);
      await Future<void>.delayed(_settle);
      final photos = c.read(timelineProvider).value!.month(key).photos;
      expect(photos.length, 1300);
      expect({for (final p in photos) p.id}.length, 1300);
      expect(repo.pageRequests.length, 3);
    });

    test(
      'only the newest ~1000 blurhashes are cached, plus every month',
      () async {
        final repo = BigLibrary();
        final c = _container(repo);
        await c.read(timelineProvider.future);
        final t = c.read(timelineProvider.notifier);
        for (final b in repo.buckets.take(4)) {
          t.track(b.key, 1);
        }
        await Future<void>.delayed(_settle);
        await Future<void>.delayed(_settle);

        final cached = await TimelineCache().read();
        expect(cached.buckets.length, 120);
        expect(
          cached.photos.length,
          lessThanOrEqualTo(TimelineCache.maxPhotos),
        );
        expect(cached.photos.length, greaterThanOrEqualTo(500));
        // Newest first, so what is kept is the recent end.
        expect(
          cached.photos.first.id,
          startsWith('m${repo.buckets.first.key}-'),
        );
      },
    );

    test(
      'cached months and blurhashes paint before the network answers',
      () async {
        final repo = BigLibrary();
        final c1 = _container(repo);
        await c1.read(timelineProvider.future);
        final t = c1.read(timelineProvider.notifier);
        t.track(repo.buckets.first.key, 1);
        await Future<void>.delayed(_settle);
        await Future<void>.delayed(_settle);

        // New launch, Tor not up yet: signed out, but the cache is there.
        final c2 = _container(BigLibrary(), signedIn: false);
        final s = await c2.read(timelineProvider.future);
        expect(s.buckets.length, 120);
        expect(s.month(repo.buckets.first.key).photos.length, 500);
        expect(
          s.month(repo.buckets.first.key).photos.first.blurhash,
          isNotEmpty,
        );
      },
    );

    test('a failed refresh keeps what is shown and a retry recovers', () async {
      final repo = BigLibrary();
      final c = _container(repo);
      await c.read(timelineProvider.future);
      final t = c.read(timelineProvider.notifier);
      repo.offline = true;
      await t.refresh();
      expect(c.read(timelineProvider).value!.buckets.length, 120);
      expect(c.read(timelineProvider).value!.error, isNotNull);
      repo.offline = false;
      await t.refresh();
      expect(c.read(timelineProvider).value!.error, isNull);
    });

    test(
      'refresh reloads the newest month and any month whose count changed',
      () async {
        final repo = BigLibrary();
        final c = _container(repo);
        await c.read(timelineProvider.future);
        final t = c.read(timelineProvider.notifier);
        final newest = repo.buckets.first.key;
        t.track(newest, 1);
        await Future<void>.delayed(_settle);
        expect(repo.pageRequests.length, 1);

        await t.refresh();
        await Future<void>.delayed(_settle);
        expect(repo.pageRequests.length, 2);
      },
    );
  });

  group('layout', () {
    test('offsets are exact and every month can be jumped to', () async {
      final repo = BigLibrary();
      final c = _container(repo);
      final s = await c.read(timelineProvider.future);
      final layout = TimelineLayout.build(s, 358, {});
      expect(layout.entries.length, 240); // header + skeleton per month
      var y = 0.0;
      for (var i = 0; i < layout.entries.length; i++) {
        expect(layout.offsets[i], y);
        y += layout.entries[i].extent;
      }
      expect(layout.total, y);
      for (final b in s.buckets) {
        final off = layout.offsetOfMonth(b.key)!;
        expect(layout.monthKeyAt(off), b.key);
        expect(layout.monthKeyAt(off + 1), b.key);
      }
    });

    test('unchanged months are not laid out again', () async {
      final repo = BigLibrary();
      final c = _container(repo);
      final s = await c.read(timelineProvider.future);
      final cache = <int, Object>{};
      final first = TimelineLayout.build(s, 358, cache);
      final entriesOf = {
        for (final b in s.buckets)
          b.key: first.entries.where((e) => e.monthKey == b.key).toList(),
      };
      final second = TimelineLayout.build(s, 358, cache);
      // Same state and width: every month reuses the entries it already had.
      for (final b in s.buckets) {
        final again = second.entries.where((e) => e.monthKey == b.key).toList();
        expect(again.length, entriesOf[b.key]!.length);
        for (var i = 0; i < again.length; i++) {
          expect(identical(again[i], entriesOf[b.key]![i]), isTrue);
        }
      }
      expect(second.total, first.total);
    });
  });

  group('widgets', () {
    Future<ProviderContainer> pumpView(
      WidgetTester tester,
      BigLibrary repo,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final c = _container(repo);
      await c.read(timelineProvider.future);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final s = ref.watch(timelineProvider).value;
                  return s == null ? const SizedBox() : TimelineView(state: s);
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(_settle);
      await tester.pump(_settle);
      return c;
    }

    testWidgets('skeletons first, then the visible month fills in', (
      tester,
    ) async {
      final repo = BigLibrary();
      await pumpView(tester, repo);
      expect(repo.pageRequests.length, 1);
      expect(find.byType(JustifiedGrid), findsWidgets);
      // Cells are rounded 8.
      expect(photoRadius, 8);
    });

    testWidgets('a loaded row is exactly as tall as the layout says', (
      tester,
    ) async {
      final repo = BigLibrary();
      await pumpView(tester, repo);
      final grid = find.byType(JustifiedGrid).first;
      final gridRect = tester.getRect(grid);
      var bottom = 0.0;
      for (final e in tester.widgetList<GestureDetector>(
        find.descendant(of: grid, matching: find.byType(GestureDetector)),
      )) {
        final key = e.key;
        if (key is ValueKey<String> && key.value.startsWith('photo-')) {
          bottom = [
            bottom,
            tester.getRect(find.byKey(key)).bottom,
          ].reduce((a, b) => a > b ? a : b);
        }
      }
      // The tallest column ends one gap above the next row.
      expect(bottom + masonryGap, closeTo(gridRect.bottom, 0.01));
      expect(tester.takeException(), isNull);
    });

    testWidgets('dragging the date handle jumps through the years', (
      tester,
    ) async {
      final repo = BigLibrary();
      await pumpView(tester, repo);
      final scroll = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      expect(scroll.position.pixels, 0);
      expect(scroll.position.maxScrollExtent, greaterThan(2500000));

      // Scroll a bit so the handle shows, then grab it.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -50));
      await tester.pump();
      final handle = find.byKey(const ValueKey('date-scrubber'));
      expect(handle, findsOneWidget);
      final g = await tester.startGesture(tester.getCenter(handle));
      await g.moveBy(const Offset(0, 800));
      await tester.pump();
      expect(find.byKey(const ValueKey('scrubber-label')), findsOneWidget);
      expect(
        scroll.position.pixels,
        greaterThan(scroll.position.maxScrollExtent * 0.5),
      );
      await g.up();
      await tester.pump(_settle);
      await tester.pump(_settle);

      // The month under the handle was fetched; the ones skipped were not.
      expect(repo.pageRequests.length, lessThan(6));
      await tester.pump(const Duration(seconds: 2));
    });
  });

  test('LifoGate runs the newest waiting task first', () async {
    final gate = LifoGate(1);
    final order = <int>[];
    final hold = Completer<void>();
    final running = gate.run(() => hold.future);
    final a = gate.run(() async => order.add(1));
    final b = gate.run(() async => order.add(2));
    final c = gate.run(() async => order.add(3));
    hold.complete();
    await Future.wait([running, a, b, c]);
    expect(order, [3, 2, 1]);
  });

  test(
    'PriorityGate starts the lowest priority first, re-read at dequeue',
    () async {
      final gate = PriorityGate(1, coalesce: Duration.zero);
      final order = <String>[];
      final hold = Completer<void>();
      final running = gate.run(() => hold.future, priority: () => 0);
      final prio = {'a': 30.0, 'b': 10.0, 'c': 20.0};
      final tasks = [
        for (final k in prio.keys)
          gate.run(() async => order.add(k), priority: () => prio[k]),
      ];
      await Future<void>.delayed(const Duration(milliseconds: 5));
      prio['a'] = 1; // scrolled: now the most urgent
      hold.complete();
      await Future.wait([running, ...tasks]);
      expect(order, ['a', 'b', 'c']);
    },
  );

  test('PriorityGate keeps ineligible tasks waiting until nudged', () async {
    final gate = PriorityGate(2, coalesce: Duration.zero);
    double? p;
    var ran = false;
    final t = gate.run(() async => ran = true, priority: () => p);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(ran, isFalse);
    p = 1;
    gate.nudge();
    await t;
    expect(ran, isTrue);
  });
}
