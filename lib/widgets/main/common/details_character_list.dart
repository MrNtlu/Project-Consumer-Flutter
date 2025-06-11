import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/pages/main/actor/actor_content_page.dart';

class DetailsCommonList extends StatelessWidget {
  final bool isAvatar;
  final int listCount;
  final IconData placeHolderIcon;
  final String Function(int)? getActorID;
  final String? Function(int) getImage;
  final String Function(int) getName;
  final String Function(int)? getCharacter;
  final void Function(int)? onClick;
  final bool isMovie;

  const DetailsCommonList(
    this.isAvatar,
    this.listCount,
    this.getActorID,
    this.getImage,
    this.getName,
    this.getCharacter,
    this.isMovie, {
    this.placeHolderIcon = Icons.person,
    this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return SizedBox(
      height: 170,
      child: ListView.builder(
        itemCount: listCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final image = getImage(index);
          final name = getName(index);

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == listCount - 1 ? 0 : 8,
            ),
            child: _buildCharacterCard(
              context,
              index,
              image,
              name,
              theme,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCharacterCard(
    BuildContext context,
    int index,
    String? image,
    String name,
    CupertinoThemeData theme,
  ) {
    return GestureDetector(
      onTap: () => _handleCardTap(context, index, name, image),
      behavior: HitTestBehavior.opaque,
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
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: isAvatar ? 1.0 : 16 / 9,
                    child: image != null
                        ? _buildNetworkImage(image, theme)
                        : _buildPlaceholder(theme),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: _buildCharacterInfo(name, index, theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String image, CupertinoThemeData theme) {
    if (isAvatar) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: image,
          key: ValueKey<String>(image),
          cacheKey: image,
          filterQuality: FilterQuality.medium,
          fit: BoxFit.cover,
          cacheManager: CustomCacheManager(),
          maxHeightDiskCache: 200,
          maxWidthDiskCache: 200,
          errorListener: (_) {},
          errorWidget: (context, _, __) => _buildErrorWidget(theme),
          progressIndicatorBuilder: (_, __, ___) => _buildLoadingWidget(theme),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(2),
        child: CachedNetworkImage(
          imageUrl: image,
          key: ValueKey<String>(image),
          cacheKey: image,
          fit: BoxFit.contain,
          cacheManager: CustomCacheManager(),
          maxHeightDiskCache: 240,
          maxWidthDiskCache: 280,
          errorListener: (_) {},
          errorWidget: (context, _, __) => _buildErrorWidget(theme),
          progressIndicatorBuilder: (_, __, ___) => _buildLoadingWidget(theme),
        ),
      );
    }
  }

  Widget _buildPlaceholder(CupertinoThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.bgTextColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        placeHolderIcon,
        size: 40,
        color: theme.bgTextColor.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildLoadingWidget(CupertinoThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Shimmer.fromColors(
        baseColor: theme.bgTextColor.withValues(alpha: 0.1),
        highlightColor: theme.bgTextColor.withValues(alpha: 0.05),
        child: Container(
          color: theme.bgTextColor.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(CupertinoThemeData theme) {
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

  Widget _buildCharacterInfo(String name, int index, CupertinoThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: theme.bgTextColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        if (getCharacter != null) ...[
          const SizedBox(height: 2),
          Text(
            getCharacter!(index),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: theme.bgTextColor.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  void _handleCardTap(
      BuildContext context, int index, String name, String? image) {
    if (onClick != null) {
      onClick!(index);
      return;
    }

    if (isAvatar && getActorID != null && image != null) {
      Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(
          builder: (_) {
            return ActorContentPage(
              getActorID!(index),
              name,
              image,
              isMovie: isMovie,
            );
          },
        ),
      );
    }
  }
}
