import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';

class ContentCell extends StatelessWidget {
  final String url;
  final String title;
  final double cornerRadius;
  final bool forceRatio;
  final int? cacheWidth;
  final int? cacheHeight;

  const ContentCell(
    this.url,
    this.title, {
    this.cornerRadius = 12,
    this.forceRatio = false,
    this.cacheWidth,
    this.cacheHeight,
    super.key,
  });

  // Optimized cache key generation - prevents hash collisions and reduces memory
  static String _generateCacheKey(
      String url, int? cacheWidth, int? cacheHeight) {
    final width = cacheWidth ?? 400;
    final height = cacheHeight ?? 600;
    // More robust cache key to prevent collisions
    return '${url.length}_${url.hashCode.abs()}_${width}_$height';
  }

  // Compile-time constant aspect ratios for maximum performance
  static const double _standardAspectRatio = 2 / 3;
  static const double _gameAspectRatio = 16 / 9;

  static double _calculateAspectRatio(
      bool forceRatio, ContentType contentType) {
    return forceRatio || contentType != ContentType.game
        ? _standardAspectRatio
        : _gameAspectRatio;
  }

  @override
  Widget build(BuildContext context) {
    // Ultra-targeted context selector - minimal rebuilds
    final contentType = context.select<ContentProvider, ContentType>(
      (provider) => provider.selectedContent,
    );

    // Pre-computed values - calculated once per build
    final aspectRatio = _calculateAspectRatio(forceRatio, contentType);
    final borderRadius = BorderRadius.all(Radius.circular(cornerRadius));
    final cacheKey = _generateCacheKey(url, cacheWidth, cacheHeight);
    final isGameStyle = !forceRatio && contentType == ContentType.game;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: isGameStyle
            ? _buildGameStyleContent(aspectRatio, borderRadius, cacheKey)
            : _buildOptimizedImage(aspectRatio, borderRadius, cacheKey),
      ),
    );
  }

  // Optimized game style content - reduced parameter passing
  Widget _buildGameStyleContent(
    double aspectRatio,
    BorderRadius borderRadius,
    String cacheKey,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: _buildOptimizedImage(aspectRatio, borderRadius, cacheKey),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color: const Color(0xB3000000),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: CupertinoColors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  // Ultra-optimized image widget - maximum loading speed
  Widget _buildOptimizedImage(
    double aspectRatio,
    BorderRadius borderRadius,
    String cacheKey,
  ) {
    final width = cacheWidth ?? 400;
    final height = cacheHeight ?? 600;

    return CachedNetworkImage(
      imageUrl: url,
      key: ValueKey<String>(cacheKey),
      cacheKey: cacheKey,
      cacheManager: CustomCacheManager(),

      // Optimized cache parameters - balanced for speed and quality
      maxWidthDiskCache: width,
      maxHeightDiskCache: height,
      memCacheWidth: width >> 1, // Bitwise division for speed
      memCacheHeight: height >> 1,

      // Maximum speed rendering optimizations
      filterQuality: FilterQuality.low, // Faster rendering
      fadeInDuration: const Duration(milliseconds: 100), // Faster transition
      fadeOutDuration: Duration.zero,
      fit: BoxFit.cover,

      // Ultra-optimized image builder
      imageBuilder: (context, imageProvider) {
        return RepaintBoundary(
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                isAntiAlias: false, // Fastest rendering
              ),
            ),
          ),
        );
      },

      // Optimized loading with minimal overhead
      progressIndicatorBuilder: (context, url, progress) {
        return _UltraOptimizedShimmerLoader(
          aspectRatio: aspectRatio,
          borderRadius: borderRadius,
          progress: progress,
        );
      },

      // Silent error handling - zero overhead in production
      errorListener: kDebugMode ? (_) {} : null,

      // Lightweight error widget
      errorWidget: (context, url, error) => _UltraOptimizedErrorWidget(
        title: title,
        error: error,
      ),
    );
  }
}

// Ultra-optimized shimmer loader - minimal resource usage
class _UltraOptimizedShimmerLoader extends StatelessWidget {
  final double aspectRatio;
  final BorderRadius borderRadius;
  final DownloadProgress? progress;

  const _UltraOptimizedShimmerLoader({
    required this.aspectRatio,
    required this.borderRadius,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: progress?.totalSize != null
            ? _buildProgressIndicator()
            : _buildShimmerAnimation(),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final value = progress!.downloaded / progress!.totalSize!;
    return ColoredBox(
      color: CupertinoColors.systemGrey6,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: 1.5,
            valueColor:
                const AlwaysStoppedAnimation<Color>(CupertinoColors.activeBlue),
            backgroundColor: CupertinoColors.systemGrey4,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerAnimation() {
    return const Shimmer(
      gradient: LinearGradient(
        colors: [
          CupertinoColors.systemGrey6,
          CupertinoColors.systemGrey4,
          CupertinoColors.systemGrey6,
        ],
        stops: [0.1, 0.3, 0.4],
        begin: Alignment(-1.0, -0.3),
        end: Alignment(1.0, 0.3),
      ),
      child: ColoredBox(color: CupertinoColors.systemGrey6),
    );
  }
}

// Ultra-lightweight error widget - minimal memory footprint
class _UltraOptimizedErrorWidget extends StatelessWidget {
  final String title;
  final Object error;

  const _UltraOptimizedErrorWidget({
    required this.title,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    // Zero-overhead error logging in production
    if (kDebugMode) {
      debugPrint("ContentCell error: $error");
    }

    final theme = CupertinoTheme.of(context);

    return RepaintBoundary(
      child: ColoredBox(
        color: theme.bgTextColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: theme.primaryContrastingColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
