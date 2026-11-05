import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/data/models.dart';
import '../../../core/providers.dart';
import '../../../core/timeline/timeline_controller.dart';
import '../../../core/utils/image_helpers.dart';
import '../../../core/utils/thumb_interest.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/person_avatar.dart';

const _months = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', //
  'septiembre', 'octubre', 'noviembre', 'diciembre',
];

String _two(int n) => n.toString().padLeft(2, '0');

String longDate(DateTime d) =>
    '${d.day} de ${_months[d.month - 1]}, ${d.year} · ${_two(d.hour)}:${_two(d.minute)}';

String shortDate(DateTime d) =>
    '${d.day} ${_months[d.month - 1].substring(0, 3)} ${d.year}';

/// What the router passes to the viewer: the tapped photo and, optionally,
/// the list it came from so the user can swipe to its neighbours.
class ViewerArgs {
  const ViewerArgs(this.photo, [this.photos]);
  final Photo photo;
  final List<Photo>? photos;
}

/// Opens the viewer on [photo]. Without [photos] the timeline is used.
void openPhoto(BuildContext context, Photo photo, [List<Photo>? photos]) =>
    context.push('/photo/${photo.id}', extra: ViewerArgs(photo, photos));

class PhotoViewerScreen extends ConsumerStatefulWidget {
  const PhotoViewerScreen({
    super.key,
    required this.photoId,
    this.initial,
    this.photos,
  });

  final String photoId;

  /// The photo as the list that opened the viewer already has it (blurhash,
  /// aspect), so the first frame needs no lookup.
  final Photo? initial;

  /// Photos to swipe through, in display order; the timeline when null.
  final List<Photo>? photos;

  @override
  ConsumerState<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends ConsumerState<PhotoViewerScreen> {
  late final List<Photo> _photos;
  late final PageController _pager;
  late int _index;

  /// Swiping is off while the photo is zoomed in, so panning it does not
  /// turn the page.
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    var list = widget.photos ?? ref.read(timelineProvider).value?.allPhotos;
    var i = list?.indexWhere((p) => p.id == widget.photoId) ?? -1;
    if (list == null || i < 0) {
      list = [?widget.initial];
      i = list.isEmpty ? -1 : 0;
    }
    _photos = list;
    _index = i < 0 ? 0 : i;
    _pager = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  String get _currentId =>
      _photos.isEmpty ? widget.photoId : _photos[_index].id;

  void _onPage(int i) {
    setState(() {
      _index = i;
      _zoomed = false;
    });
    // Warm the neighbours so the next swipe shows a picture straight away.
    for (final n in [i - 1, i + 1]) {
      if (n >= 0 && n < _photos.length) {
        thumbInterest.pin(_photos[n].id);
        ref.read(thumbnailProvider(_photos[n].id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = _currentId;
    final details = ref.watch(photoDetailsProvider(id));
    return Scaffold(
      backgroundColor: AppColors.viewerBg,
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF6B2D97), AppColors.viewerBg],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: _photos.length <= 1
                ? _PhotoArea(id, widget.initial, onZoom: (z) => _zoomed = z)
                : PageView.builder(
                    key: const ValueKey('viewer-pager'),
                    controller: _pager,
                    physics: _zoomed
                        ? const NeverScrollableScrollPhysics()
                        : const PageScrollPhysics(),
                    itemCount: _photos.length,
                    onPageChanged: _onPage,
                    itemBuilder: (_, i) => _PhotoArea(
                      _photos[i].id,
                      _photos[i],
                      key: ValueKey('page-${_photos[i].id}'),
                      active: i == _index,
                      onZoom: (z) {
                        if (z != _zoomed && i == _index) {
                          setState(() => _zoomed = z);
                        }
                      },
                    ),
                  ),
          ),
          // One sheet for every state: swapping it for a new one when the
          // details arrive reset the drag and could leave the screen empty.
          _SheetShell(
            children: details.when(
              loading: () => const [
                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              error: (e, _) => const [
                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(
                    child: Text(
                      'No se pudieron cargar los detalles',
                      style: TextStyle(fontSize: 13, color: AppColors.stem),
                    ),
                  ),
                ),
              ],
              data: (d) => _sheetChildren(context, d),
            ),
          ),
          SafeArea(child: _TopBar(id, key: ValueKey('bar-$id'))),
        ],
      ),
    );
  }
}

/// The photo itself, full screen, in three layers that replace each other as
/// bytes arrive: blurhash (cached from the timeline), then the thumbnail, then
/// the original.
class _PhotoArea extends ConsumerStatefulWidget {
  const _PhotoArea(
    this.photoId,
    this.initial, {
    super.key,
    this.onZoom,
    this.active = true,
  });
  final String photoId;
  final Photo? initial;

  /// Only the page the user stopped on downloads the original, so swiping
  /// past photos does not start a heavy download for each of them.
  final bool active;

  /// Called with true while the photo is zoomed in.
  final ValueChanged<bool>? onZoom;

  @override
  ConsumerState<_PhotoArea> createState() => _PhotoAreaState();
}

class _PhotoAreaState extends ConsumerState<_PhotoArea> {
  final _transform = TransformationController();
  bool _zoomed = false;

  Timer? _fullTimer;
  bool _wantFull = false;

  void _scheduleFull() {
    _fullTimer?.cancel();
    if (!widget.active || _wantFull) return;
    _fullTimer = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _wantFull = true);
    });
  }

  @override
  void didUpdateWidget(_PhotoArea old) {
    super.didUpdateWidget(old);
    if (widget.active != old.active) {
      widget.active ? _scheduleFull() : _fullTimer?.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _scheduleFull();
    _transform.addListener(() {
      final z = _transform.value.getMaxScaleOnAxis() > 1.02;
      if (z != _zoomed) {
        _zoomed = z;
        widget.onZoom?.call(z);
      }
    });
  }

  @override
  void dispose() {
    _fullTimer?.cancel();
    _transform.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photoId = widget.photoId;
    final initial = widget.initial;
    final meta = initial ?? ref.watch(photoMetaProvider(photoId));
    thumbInterest.pin(photoId);
    final thumb = ref.watch(thumbnailProvider(photoId)).value;
    final full = _wantFull
        ? ref.watch(photoBytesProvider(photoId)).value
        : null;
    final hasThumb = thumb != null && thumb.isNotEmpty;
    final hasFull = full != null && full.isNotEmpty;
    final blurhash = meta?.blurhash ?? '';
    if (!hasThumb && !hasFull && blurhash.isEmpty) {
      return const Center(
        child: Icon(
          AppIcons.image,
          key: ValueKey('viewer-placeholder'),
          size: 84,
          color: Color(0x40FFFFFF),
        ),
      );
    }
    final aspect = (meta?.aspect ?? 0) > 0
        ? meta!.aspect
        : (meta?.tall ?? false)
        ? 3 / 4
        : 4 / 3;
    return InteractiveViewer(
      transformationController: _transform,
      maxScale: 5,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Same box for blurhash and thumbnail so they line up.
          Center(
            child: AspectRatio(
              aspectRatio: aspect,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (blurhash.isNotEmpty) BlurHash(hash: blurhash),
                  if (hasThumb)
                    Image.memory(
                      thumb,
                      key: const ValueKey('viewer-thumb'),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                ],
              ),
            ),
          ),
          if (hasFull)
            Center(
              child: Image.memory(
                full,
                key: const ValueKey('viewer-image'),
                fit: BoxFit.contain,
                gaplessPlayback: true,
                frameBuilder: (_, child, frame, sync) => AnimatedOpacity(
                  opacity: sync || frame != null ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: child,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TopBar extends ConsumerStatefulWidget {
  const _TopBar(this.photoId, {super.key});
  final String photoId;

  @override
  ConsumerState<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends ConsumerState<_TopBar> {
  /// Set once the user taps the heart; until then the server value is shown.
  bool? _favorite;
  bool _busy = false;
  bool _sharing = false;

  bool get _isFavorite =>
      _favorite ??
      ref.watch(photoDetailsProvider(widget.photoId)).value?.favorite ??
      false;

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _toggleFavorite() async {
    if (_busy) return;
    final before = _isFavorite;
    setState(() {
      _busy = true;
      _favorite = !before; // optimistic
    });
    try {
      final now = await ref
          .read(photoRepositoryProvider)
          .toggleFavorite(widget.photoId);
      if (mounted) setState(() => _favorite = now);
    } catch (_) {
      if (mounted) setState(() => _favorite = before);
      _toast('No se pudo actualizar favoritos');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share() async {
    if (_sharing) return;
    _sharing = true;
    try {
      final bytes = await ref.read(photoBytesProvider(widget.photoId).future);
      final png =
          bytes.length > 4 && bytes[0] == 0x89 && bytes[1] == 0x50; // \x89PNG
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              mimeType: png ? 'image/png' : 'image/jpeg',
              name: png ? 'foto.png' : 'foto.jpg',
            ),
          ],
        ),
      );
    } catch (_) {
      _toast('No se pudo compartir la foto');
    } finally {
      _sharing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fav = _isFavorite;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          _Round(AppIcons.arrowLeft, 'back', () => context.pop()),
          const Spacer(),
          _Round(AppIcons.share2, 'share', _share),
          const SizedBox(width: 10),
          _Round(
            AppIcons.heart,
            'favorite',
            _toggleFavorite,
            color: fav ? const Color(0xFFFF5C7A) : Colors.white,
            filled: fav,
          ),
          const SizedBox(width: 10),
          _MoreMenu(widget.photoId),
        ],
      ),
    );
  }
}

/// Photo menu: add to an album and delete work; edit is not there yet.
class _MoreMenu extends ConsumerWidget {
  const _MoreMenu(this.photoId);
  final String photoId;

  void _toast(ScaffoldMessengerState messenger, String msg) => messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _addToAlbum(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final choice = await showModalBottomSheet<_AlbumChoice>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.r28),
        ),
      ),
      builder: (_) => const _AlbumSheet(),
    );
    if (choice == null || !context.mounted) return;
    try {
      var album = choice.album;
      album ??= await ref.read(albumRepositoryProvider).create(choice.newName!);
      await ref.read(photoRepositoryProvider).addToAlbum(photoId, album.id);
      ref.invalidate(albumsProvider);
      ref.invalidate(albumPhotosProvider(album.id));
      _toast(messenger, 'Añadida a «${album.name}»');
    } catch (_) {
      _toast(messenger, 'No se pudo agregar al álbum');
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r28),
        ),
        title: const Text('¿Eliminar esta foto?'),
        content: const Text(
          'Se borra del servidor, con su miniatura y sus álbumes. '
          'No se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            key: const ValueKey('confirm-delete'),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppColors.destructive),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await ref.read(photoRepositoryProvider).delete(photoId);
    } catch (_) {
      _toast(messenger, 'No se pudo eliminar la foto');
      return;
    }
    // Everything that lists photos must forget this one.
    ref.invalidate(albumsProvider);
    ref.invalidate(albumPhotosProvider);
    ref.invalidate(peopleProvider);
    ref.invalidate(personDetailsProvider);
    unawaited(ref.read(timelineProvider.notifier).refresh());
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      key: const ValueKey('viewer-more'),
      tooltip: 'Más opciones',
      offset: const Offset(0, 48),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      onSelected: (v) {
        if (v == 'album') _addToAlbum(context, ref);
        if (v == 'delete') _delete(context, ref);
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'edit',
          enabled: false, // coming later
          child: _MenuRow(AppIcons.pencil, 'Editar', AppColors.stem),
        ),
        PopupMenuItem(
          value: 'album',
          child: _MenuRow(
            AppIcons.folderHeart,
            'Agregar a álbum',
            AppColors.ink,
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: _MenuRow(AppIcons.trash, 'Eliminar', AppColors.destructive),
        ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          shape: BoxShape.circle,
        ),
        child: const Icon(AppIcons.moreVertical, size: 20, color: Colors.white),
      ),
    );
  }
}

/// What the album sheet returns: an existing album, or the name of a new one.
class _AlbumChoice {
  const _AlbumChoice.existing(Album this.album) : newName = null;
  const _AlbumChoice.create(String this.newName) : album = null;
  final Album? album;
  final String? newName;
}

class _AlbumSheet extends ConsumerWidget {
  const _AlbumSheet();

  Future<void> _newAlbum(BuildContext context, List<Album> existing) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r28),
        ),
        title: const Text('Nuevo álbum'),
        content: TextField(
          key: const ValueKey('sheet-new-album-name'),
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nombre del álbum'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty || !context.mounted) return;
    // Album names are unique: an existing one with that name is reused.
    final same = existing.where((a) => a.name == name);
    Navigator.pop(
      context,
      same.isNotEmpty
          ? _AlbumChoice.existing(same.first)
          : _AlbumChoice.create(name),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(albumsProvider);
    final list = albums.value ?? const <Album>[];
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Agregar a álbum',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            ListTile(
              key: const ValueKey('sheet-new-album'),
              leading: const Icon(AppIcons.plus, color: AppColors.deep),
              title: const Text('Nuevo álbum'),
              onTap: () => _newAlbum(context, list),
            ),
            Flexible(
              child: albums.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
                error: (_, _) => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No se pudieron cargar los álbumes'),
                ),
                data: (items) => ListView(
                  shrinkWrap: true,
                  children: [
                    for (final a in items)
                      ListTile(
                        key: ValueKey('sheet-album-${a.id}'),
                        leading: const Icon(
                          AppIcons.folderHeart,
                          color: AppColors.stem,
                        ),
                        title: Text(a.name),
                        subtitle: Text('${a.photoCount} fotos'),
                        onTap: () =>
                            Navigator.pop(context, _AlbumChoice.existing(a)),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow(this.icon, this.label, this.color);
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(width: 10),
      Text(
        label,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    ],
  );
}

class _Round extends StatelessWidget {
  const _Round(
    this.icon,
    this.tag,
    this.onTap, {
    this.color = Colors.white,
    this.filled = false,
  });
  final IconData icon;
  final String tag;
  final VoidCallback onTap;
  final Color color;

  /// Toggle state: draws the icon as a solid shape.
  final bool filled;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withValues(alpha: 0.14),
    shape: const CircleBorder(),
    child: InkWell(
      key: ValueKey('viewer-$tag'),
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        // Lucide has no solid variant, so a favorited heart uses Material's.
        child: Icon(filled ? Icons.favorite : icon, size: 20, color: color),
      ),
    ),
  );
}

/// The bottom sheet frame. It is there from the start so the user can drag it
/// up even while the details are still loading.
class _SheetShell extends StatelessWidget {
  const _SheetShell({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      // Collapsed by default: only a handle peeks out. Drag up for details.
      initialChildSize: 0.085,
      minChildSize: 0.085,
      maxChildSize: 0.92,
      snap: true,
      snapSizes: const [0.55],
      builder: (context, scroll) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.r32),
          ),
        ),
        child: ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
          children: [
            Center(
              child: Container(
                key: const ValueKey('viewer-sheet-handle'),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lavender,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _FaceAvatar extends ConsumerWidget {
  const _FaceAvatar({required this.face});

  final FaceInPhoto face;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final people = ref.watch(peopleProvider).value ?? const <Person>[];
    for (final p in people) {
      if (p.id == face.personId) {
        return PersonAvatar(person: p, size: 52, ring: 2);
      }
    }
    return AvatarCircle(size: 52, ring: 2, seed: face.seed);
  }
}

List<Widget> _sheetChildren(BuildContext context, PhotoDetails d) {
  return [
    Row(
      children: [
        const AvatarCircle(size: 44, ring: 2),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subida por ${d.uploader}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              Text(
                longDate(d.photo.takenAt),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.stem),
              ),
            ],
          ),
        ),
      ],
    ),
    if (d.faces.isNotEmpty) ...[
      const SizedBox(height: 18),
      const SectionTitle('Personas en esta foto'),
      const SizedBox(height: 10),
      SizedBox(
        height: 78,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: d.faces.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, i) {
            final f = d.faces[i];
            return GestureDetector(
              key: ValueKey('face-${f.personId}'),
              onTap: () => context.push('/person/${f.personId}'),
              child: Column(
                children: [
                  _FaceAvatar(face: f),
                  const SizedBox(height: 5),
                  Text(
                    '${f.name} · ${(f.confidence * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
    const SizedBox(height: 14),
    Row(
      children: [
        Expanded(
          child: _Chip(AppIcons.calendar, shortDate(d.photo.takenAt), 'Fecha'),
        ),
        const SizedBox(width: 10),
        Expanded(child: _Chip(AppIcons.mapPin, d.placeName, 'Ubicación')),
      ],
    ),
    const SizedBox(height: 10),
    Row(
      children: [
        Expanded(
          child: _Chip(
            AppIcons.camera,
            'ISO ${d.iso} · f/${d.aperture}',
            'Cámara',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Chip(
            AppIcons.shieldCheck,
            d.encryptedAtRest ? 'AES-256' : 'Sin cifrar',
            'Cifrado en reposo',
          ),
        ),
      ],
    ),
    const SizedBox(height: 16),
    Row(
      children: [
        const Expanded(child: _Action('Editar información')),
        const SizedBox(width: 8),
        Expanded(
          child: _Action('Agregar a álbum', onTap: () => context.go('/albums')),
        ),
        const SizedBox(width: 8),
        const Expanded(child: _Action('Eliminar', destructive: true)),
      ],
    ),
  ];
}

class _Chip extends StatelessWidget {
  const _Chip(this.icon, this.value, this.label);
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    decoration: BoxDecoration(
      color: AppColors.inputBg,
      borderRadius: BorderRadius.circular(AppRadius.r16),
    ),
    child: Row(
      children: [
        Icon(icon, size: 18, color: AppColors.stem),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: AppColors.stem),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Action extends StatelessWidget {
  const _Action(this.label, {this.destructive = false, this.onTap});
  final String label;
  final bool destructive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.destructive : AppColors.deep;
    return SizedBox(
      height: 50,
      child: Material(
        color: destructive ? AppColors.destructiveBg : Colors.white,
        shape: StadiumBorder(
          side: BorderSide(
            color: destructive ? const Color(0xFFF3C7D1) : AppColors.floral,
          ),
        ),
        child: InkWell(
          key: ValueKey('action-$label'),
          customBorder: const StadiumBorder(),
          onTap: onTap ?? () {},
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
