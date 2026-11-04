import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_theme.dart';

class _Tab {
  const _Tab(this.path, this.label, this.icon);
  final String path;
  final String label;
  final IconData icon;
}

const _tabs = [
  _Tab('/photos', 'Fotos', AppIcons.image),
  _Tab('/people', 'Personas', AppIcons.users),
  _Tab('/albums', 'Álbumes', AppIcons.folderHeart),
  _Tab('/places', 'Lugares', AppIcons.mapPin),
];

/// Shell for the four tabs with the floating glass bar.
class MainNavigationWrapper extends StatelessWidget {
  const MainNavigationWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere((t) => location.startsWith(t.path));
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
            left: 16,
            right: 16,
            bottom: 12 + MediaQuery.of(context).padding.bottom,
            child: _GlassBar(
              selected: index,
              onSelect: (i) => context.go(_tabs[i].path),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassBar extends StatelessWidget {
  const _GlassBar({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.r28);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: shape,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.78),
              borderRadius: shape,
              border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: _TabItem(
                      tab: _tabs[i],
                      active: i == selected,
                      onTap: () => onSelect(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final _Tab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.deep : AppColors.stem;
    return GestureDetector(
      key: ValueKey('tab-${tab.label}'),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? AppColors.floral.withValues(alpha: 0.28)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.r22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tab.icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
