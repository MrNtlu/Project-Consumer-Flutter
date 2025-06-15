import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/main/actor/actor_content_page.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class PreviewActorList extends StatelessWidget {
  const PreviewActorList({super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final PreviewProvider previewProvider =
        Provider.of<PreviewProvider>(context);
    final ContentProvider contentProvider =
        Provider.of<ContentProvider>(context);

    return SizedBox(
      height: 170,
      child: previewProvider.networkState == NetworkState.success
          ? _buildActorList(
              context,
              previewProvider,
              contentProvider,
              cupertinoTheme,
            )
          : _buildHighPerformanceLoadingList(cupertinoTheme),
    );
  }

  Widget _buildActorList(
    BuildContext context,
    PreviewProvider previewProvider,
    ContentProvider contentProvider,
    CupertinoThemeData theme,
  ) {
    final isMovie = contentProvider.selectedContent == ContentType.movie;
    final actors = isMovie
        ? previewProvider.moviePreview.actors
        : previewProvider.tvPreview.actors;

    if (actors == null || actors.isEmpty) {
      return Center(
        child: Text(
          "No actors available",
          style: TextStyle(
            color: theme.textTheme.textStyle.color,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: actors.length,
      itemBuilder: (context, index) {
        final actor = actors[index];

        return Padding(
          padding: index == 0
              ? const EdgeInsets.only(left: 8, right: 6)
              : const EdgeInsets.symmetric(horizontal: 6),
          child: _buildActorCard(
            context,
            actor,
            theme,
            isMovie,
          ),
        );
      },
    );
  }

  Widget _buildActorCard(
    BuildContext context,
    dynamic actor,
    CupertinoThemeData theme,
    bool isMovie,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _navigateToActorPage(context, actor, isMovie),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: theme.onBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.bgTextColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _buildActorImage(actor, theme),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      actor.name.isNotEmpty ? actor.name : "Unknown",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: theme.bgTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
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

  Widget _buildActorImage(dynamic actor, CupertinoThemeData theme) {
    final imageUrl = actor.image?.replaceFirst("original", "w200") ?? '';

    if (imageUrl.isEmpty) {
      return _buildPlaceholderImage(theme);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheKey: actor.image,
      filterQuality: FilterQuality.low,
      fit: BoxFit.cover,
      cacheManager: CustomCacheManager(),
      maxHeightDiskCache: 300,
      maxWidthDiskCache: 300,
      errorListener: (_) {},
      errorWidget: (context, _, __) => _buildPlaceholderImage(theme),
      progressIndicatorBuilder: (_, __, ___) =>
          _buildHighPerformanceLoadingImage(theme),
    );
  }

  Widget _buildPlaceholderImage(CupertinoThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.bgTextColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        CupertinoIcons.person_crop_circle,
        size: 40,
        color: theme.bgTextColor.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildHighPerformanceLoadingImage(CupertinoThemeData theme) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.bgTextColor.withValues(alpha: 0.1),
                theme.bgTextColor.withValues(alpha: 0.05),
                theme.bgTextColor.withValues(alpha: 0.08),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Center(
            child: Icon(
              CupertinoIcons.person_crop_circle,
              size: 24,
              color: theme.bgTextColor.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHighPerformanceLoadingList(CupertinoThemeData theme) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        20,
        (index) => Padding(
          padding: index == 0
              ? const EdgeInsets.only(left: 8, right: 6)
              : const EdgeInsets.symmetric(horizontal: 6),
          child: RepaintBoundary(
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                color: theme.onBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: CupertinoColors.systemGrey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            CupertinoColors.systemGrey6,
                            CupertinoColors.systemGrey5,
                            CupertinoColors.systemGrey4,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.person_crop_circle,
                          size: 28,
                          color: CupertinoColors.systemGrey3,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            CupertinoColors.systemGrey6,
                            CupertinoColors.systemGrey5,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToActorPage(BuildContext context, dynamic actor, bool isMovie) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (_) {
          return ActorContentPage(
            actor.tmdbID,
            actor.name,
            actor.image,
            isMovie: isMovie,
          );
        },
      ),
    );
  }
}
