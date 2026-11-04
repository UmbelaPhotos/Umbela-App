import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:umbela_app/app/app.dart';
import 'package:umbela_app/core/data/models.dart';
import 'package:umbela_app/core/providers.dart';
import 'package:umbela_app/core/security/kek_deriver.dart';
import 'package:umbela_app/core/storage/secure_storage.dart';
import 'package:umbela_app/core/widgets/common.dart';
import 'package:umbela_app/core/widgets/photo_grid.dart';
import 'package:umbela_app/features/auth/presentation/login_screen.dart';

class FastDeriver implements KekDeriver {
  @override
  Future<Uint8List> derive(String password, Uint8List salt) async =>
      Uint8List.fromList(List.filled(32, password.length));
}

class MemoryVault implements KekVault {
  Uint8List? kek;
  bool? biometric;
  int reads = 0;

  @override
  Future<void> write(Uint8List value, {required bool biometric}) async {
    kek = Uint8List.fromList(value);
    this.biometric = biometric;
  }

  @override
  Future<Uint8List?> read({required bool biometric}) async {
    reads++;
    return kek == null ? null : Uint8List.fromList(kek!);
  }

  @override
  Future<void> delete() async => kek = null;
}

class Harness {
  Harness(this.container, this.vault);
  final ProviderContainer container;
  final MemoryVault vault;
}

Future<Harness> _pumpApp(
  WidgetTester tester, {
  Map<String, String> stored = const {},
  Uint8List? vaultKek,
}) async {
  FlutterSecureStorage.setMockInitialValues({...stored});
  tester.view.physicalSize = const Size(900, 1900);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final vault = MemoryVault()..kek = vaultKek;
  final container = ProviderContainer(
    overrides: [
      kekDeriverProvider.overrideWithValue(FastDeriver()),
      kekVaultProvider.overrideWithValue(vault),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const UmbelaApp()),
  );
  await tester.pumpAndSettle();
  return Harness(container, vault);
}

Future<void> _pair(WidgetTester tester) async {
  await tester.tap(find.text('Escanear QR'));
  await tester.pumpAndSettle();
}

Future<void> _login(WidgetTester tester, {String password = 'secret'}) async {
  await tester.enterText(find.byKey(const ValueKey('field-pass')), password);
  await tester.pump();
  await tester.tap(find.text('Iniciar sesión').last);
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

Future<void> _openDetails(WidgetTester tester) async {
  // Let the (mock) details load first: loading swaps the sheet's contents.
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
  await tester.drag(
    find.byKey(const ValueKey('viewer-sheet-handle')),
    const Offset(0, -700),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('first run: only the QR button; password comes after pairing', (
    tester,
  ) async {
    await _pumpApp(tester);
    expect(find.text('Escanear QR'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Iniciar sesión'), findsNothing);

    await _pair(tester);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('miservidor.onion'), findsNothing);
    expect(find.text('Usuario'), findsNothing);
    expect(find.byKey(const ValueKey('switch-biometric')), findsOneWidget);
  });

  testWidgets('"Iniciar sesión" stays disabled until a password is typed', (
    tester,
  ) async {
    final h = await _pumpApp(tester);
    await _pair(tester);

    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();
    expect(h.container.read(sessionTokenProvider), isNull);

    await _login(tester);
    expect(h.container.read(sessionTokenProvider), isNotNull);
  });

  testWidgets('pair, log in: KEK is stored behind biometrics by default', (
    tester,
  ) async {
    final h = await _pumpApp(tester);
    await _pair(tester);
    expect(find.textContaining('Servidor: demo.onion'), findsOneWidget);

    await _login(tester);
    expect(find.text('Hoy'), findsOneWidget);
    expect(h.vault.kek, List.filled(32, 6));
    expect(h.vault.biometric, isTrue);
  });

  testWidgets('with the switch OFF the KEK is stored without biometrics', (
    tester,
  ) async {
    final h = await _pumpApp(tester);
    await _pair(tester);
    await tester.tap(find.byKey(const ValueKey('switch-biometric')));
    await tester.pump();
    await _login(tester);
    expect(h.vault.biometric, isFalse);
  });

  testWidgets('viewer shows the photo; details only after dragging up', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _pair(tester);
    await _login(tester);

    expect(find.byKey(const ValueKey('tor-dot')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('photo-ph1')));
    await tester.pumpAndSettle();

    final screenH =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final handle = find.byKey(const ValueKey('viewer-sheet-handle'));
    expect(tester.getTopLeft(handle).dy, greaterThan(screenH * 0.85));
    expect(find.byKey(const ValueKey('viewer-placeholder')), findsOneWidget);

    await _openDetails(tester);
    expect(tester.getTopLeft(handle).dy, lessThan(screenH * 0.5));
    expect(find.text('Subida por Valentina'), findsOneWidget);
    expect(find.text('Mamá · 98%'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('face-p1')));
    await tester.pumpAndSettle();
    expect(find.text('Álbumes donde aparece'), findsOneWidget);

    await tester.tap(find.byType(RoundBackButton));
    await tester.pumpAndSettle();
    expect(handle, findsOneWidget);
  });

  testWidgets('photo menu: add to an album, then delete the photo', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _pair(tester);
    await _login(tester);

    await tester.tap(find.byKey(const ValueKey('photo-ph1')));
    await tester.pumpAndSettle();

    // Add to an existing album.
    await tester.tap(find.byKey(const ValueKey('viewer-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Agregar a álbum'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('sheet-new-album')), findsOneWidget);
    await tester.tap(find.byType(ListTile).at(1)); // first album
    await tester.pumpAndSettle();
    expect(find.textContaining('Añadida a'), findsOneWidget);

    // Delete asks first; cancelling keeps the viewer open.
    await tester.tap(find.byKey(const ValueKey('viewer-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(find.text('¿Eliminar esta foto?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('viewer-more')), findsOneWidget);

    // Confirming deletes it and leaves the viewer.
    await tester.tap(find.byKey(const ValueKey('viewer-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm-delete')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('viewer-more')), findsNothing);
    await tester.pump(const Duration(seconds: 1)); // the timeline refresh
  });

  testWidgets('album tab opens an album view with cover, name and photos', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _pair(tester);
    await _login(tester);

    await tester.tap(find.byKey(const ValueKey('tab-Álbumes')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('album-a2')));
    await tester.pumpAndSettle();

    expect(find.text('Vacaciones'), findsOneWidget);
    expect(find.text('184 fotos'), findsOneWidget);
    expect(find.byKey(const ValueKey('album-cover')), findsOneWidget);
    expect(find.text('Hoy'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('photo-ph1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('viewer-sheet-handle')), findsOneWidget);
    // Let the people list (used by the face avatars) finish loading.
    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('tapping the album cover lets you pick another photo', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _pair(tester);
    await _login(tester);

    await tester.tap(find.byKey(const ValueKey('tab-Álbumes')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('album-a2')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('pick-cover-banner')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('album-cover')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('pick-cover-banner')), findsOneWidget);
    expect(
      find.text('Toca la foto que quieras elegir como foto principal'),
      findsOneWidget,
    );

    // Picking a photo does not open the viewer and closes the notice.
    await tester.tap(find.byKey(const ValueKey('photo-ph1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('pick-cover-banner')), findsNothing);
    expect(find.byKey(const ValueKey('viewer-sheet-handle')), findsNothing);

    // Cancelling leaves the cover alone.
    await tester.tap(find.byKey(const ValueKey('album-cover')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('pick-cover-cancel')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('pick-cover-banner')), findsNothing);
  });

  testWidgets('swiping in the viewer moves to the next photo', (tester) async {
    await _pumpApp(tester);
    await _pair(tester);
    await _login(tester);

    await tester.tap(find.byKey(const ValueKey('tab-Álbumes')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('album-a2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('photo-ph1')));
    await tester.pumpAndSettle();

    final pager = find.byKey(const ValueKey('viewer-pager'));
    expect(pager, findsOneWidget);
    final controller = tester.widget<PageView>(pager).controller!;
    final start = controller.page!;
    await tester.drag(pager, const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(controller.page, start + 1);
    await tester.drag(pager, const Offset(400, 0));
    await tester.pumpAndSettle();
    expect(controller.page, start);
    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('search finds people, albums and photos by date', (tester) async {
    await _pumpApp(tester);
    await _pair(tester);
    await _login(tester);

    await tester.tap(find.byKey(const ValueKey('search-bar')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('search-hint')), findsOneWidget);

    final field = find.byKey(const ValueKey('search-field'));
    await tester.enterText(field, 'mam');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('result-person-p1')), findsOneWidget);

    await tester.enterText(field, 'vacac');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('result-album-a2')), findsOneWidget);

    await tester.enterText(field, 'ayer');
    await tester.pumpAndSettle();
    expect(find.text('Ayer'), findsOneWidget);
    expect(find.byKey(const ValueKey('photo-ph5')), findsOneWidget);

    await tester.enterText(field, 'zzzz');
    await tester.pumpAndSettle();
    expect(find.text('Sin resultados'), findsOneWidget);

    await tester.enterText(field, 'mam');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('result-person-p1')));
    await tester.pumpAndSettle();
    expect(find.text('Álbumes donde aparece'), findsOneWidget);
  });

  testWidgets('security sheet opens above the tab bar and logs out', (
    tester,
  ) async {
    final h = await _pumpApp(tester);
    await _pair(tester);
    await _login(tester);

    await tester.tap(find.byKey(const ValueKey('settings')));
    await tester.pumpAndSettle();
    expect(find.text('Seguridad'), findsOneWidget);
    expect(find.byKey(const ValueKey('tab-Fotos')).hitTestable(), findsNothing);

    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(h.container.read(sessionTokenProvider), isNull);
    expect(h.vault.kek, isNull);
    expect(find.text('Escanear QR'), findsOneWidget);
  });

  testWidgets('tabs switch and album chip goes to Álbumes', (tester) async {
    await _pumpApp(tester);
    await _pair(tester);
    await _login(tester);

    await tester.tap(find.byKey(const ValueKey('tab-Personas')));
    await tester.pumpAndSettle();
    expect(find.text('Procesado en servidor local'), findsOneWidget);
    expect(find.text('Persona anónima 1'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('person-p1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('album-chip-a1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('album-title')), findsOneWidget);
    await tester.tap(find.byType(RoundBackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RoundBackButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('tab-Lugares')));
    await tester.pumpAndSettle();
    expect(find.text('Ciudad de México'), findsOneWidget);
  });

  testWidgets('biometrics ON: background locks and the stored KEK reopens', (
    tester,
  ) async {
    final h = await _pumpApp(tester);
    await _pair(tester);
    await _login(tester);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    expect(h.container.read(sessionTokenProvider), isNull);

    final readsBefore = h.vault.reads;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    // The unlock screen read the KEK (biometric prompt) and let the user in.
    expect(h.vault.reads, greaterThan(readsBefore));
    expect(h.container.read(sessionTokenProvider), isNotNull);
    expect(find.text('Hoy'), findsOneWidget);
  });

  testWidgets('biometrics OFF: the app never locks in background', (
    tester,
  ) async {
    final h = await _pumpApp(tester);
    await _pair(tester);
    await tester.tap(find.byKey(const ValueKey('switch-biometric')));
    await tester.pump();
    await _login(tester);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(h.container.read(sessionTokenProvider), isNotNull);
    expect(find.text('Hoy'), findsOneWidget);
  });

  testWidgets('returning user is unlocked from the stored KEK, no password', (
    tester,
  ) async {
    final pairing = demoPairing();
    final h = await _pumpApp(
      tester,
      stored: {
        'pairing': pairing.toJson(),
        'biometric': 'true',
        'kek_stored': 'true',
      },
      vaultKek: Uint8List.fromList(List.filled(32, 1)),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(h.vault.reads, 1);
    expect(find.text('Hoy'), findsOneWidget);
  });

  testWidgets('security sheet moves the KEK when the switch changes', (
    tester,
  ) async {
    final h = await _pumpApp(tester);
    await _pair(tester);
    await _login(tester);
    expect(h.vault.biometric, isTrue);

    await tester.tap(find.byKey(const ValueKey('settings')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('sheet-biometric')));
    await tester.pumpAndSettle();
    expect(h.vault.biometric, isFalse);
    expect(h.vault.kek, isNotNull);
  });

  test('groupPhotos buckets Hoy / Ayer / Este mes / month', () {
    final now = DateTime(2026, 10, 26, 12);
    Photo p(String id, DateTime t) => Photo(id: id, takenAt: t);
    final groups = groupPhotos([
      p('a', DateTime(2026, 8, 3)),
      p('b', DateTime(2026, 10, 26, 9)),
      p('c', DateTime(2026, 10, 25)),
      p('d', DateTime(2026, 10, 3)),
    ], now: now);
    expect(groups.map((g) => g.label), [
      'Hoy',
      'Ayer',
      'Este mes',
      'Agosto 2026',
    ]);
  });
}
