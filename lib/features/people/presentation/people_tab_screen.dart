import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/data/models.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/person_avatar.dart';

String personLabel(Person p, List<Person> all) {
  if (!p.isAnonymous) return p.name;
  final n = all
      .where((x) => x.isAnonymous)
      .toList()
      .indexWhere((x) => x.id == p.id);
  return 'Persona anónima ${n + 1}';
}

class PeopleTabScreen extends ConsumerWidget {
  const PeopleTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final people = ref.watch(peopleProvider);
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ColoredBox(
              color: Colors.white,
              child: SizedBox(width: double.infinity, child: AppHeader()),
            ),
            Expanded(
              child: people.when(
                skipLoadingOnReload: true,
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => reloadProvider(ref, peopleProvider),
                ),
                data: (list) => PullRefresh(
                  onRefresh: () => reloadProvider(ref, peopleProvider),
                  child: _Body(list),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.people);
  final List<Person> people;

  @override
  Widget build(BuildContext context) {
    void open(Person p) => context.push('/person/${p.id}');
    String short(Person p) => p.isAnonymous
        ? 'Anónimo ${people.where((x) => x.isAnonymous).toList().indexWhere((x) => x.id == p.id) + 1}'
        : p.name;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        const Text(
          'Personas e identidades',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: AppColors.floral),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AppIcons.shieldCheck, size: 14, color: AppColors.deep),
                SizedBox(width: 6),
                Text(
                  'Procesado en servidor local',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deep,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle('Rostros identificados'),
        const SizedBox(height: 10),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: people.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (_, i) {
              final p = people[i];
              return GestureDetector(
                key: ValueKey('face-${p.id}'),
                onTap: () => open(p),
                child: Column(
                  children: [
                    PersonAvatar(person: p, size: 60),
                    const SizedBox(height: 6),
                    Text(short(p), style: AppTextLabel.style),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        const SectionTitle('Todas las personas'),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.12,
          children: [
            for (final p in people)
              UmbelaCard(
                key: ValueKey('person-${p.id}'),
                onTap: () => open(p),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PersonAvatar(person: p, size: 56),
                    const SizedBox(height: 10),
                    Text(
                      personLabel(p, people),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${p.photoCount} fotos',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.stem,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class AppTextLabel {
  static const style = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
}
