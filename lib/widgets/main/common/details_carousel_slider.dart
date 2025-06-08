import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:watchlistfy/pages/main/image_page.dart';

class DetailsCarouselSlider extends StatelessWidget {
  final List<String> images;

  const DetailsCarouselSlider(this.images, {super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    return CarouselSlider(
      items: images.asMap().entries.map(
        (entry) {
          final index = entry.key;
          final imageUrl = entry.value;

          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                      builder: (_) {
                        return ImagePage(
                          imageUrl,
                          heroTag: 'carousel_image_$index',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  width: width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Hero(
                    tag: 'carousel_image_$index',
                    // Use Material to prevent Hero transition issues
                    child: Material(
                      color: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: _OptimizedCarouselImage(
                            imageUrl: imageUrl,
                            cacheKey: 'carousel_${imageUrl.hashCode}',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ).toList(),
      options: CarouselOptions(
        height: 250,
        aspectRatio: 16 / 9,
        viewportFraction: 0.75,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

// Optimized carousel image widget to prevent overflow issues
class _OptimizedCarouselImage extends StatelessWidget {
  final String imageUrl;
  final String cacheKey;

  const _OptimizedCarouselImage({
    required this.imageUrl,
    required this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl.replaceFirst("original", "w780"),
      key: ValueKey<String>(cacheKey),
      cacheKey: cacheKey,
      fit: BoxFit.cover,
      cacheManager: CustomCacheManager(),
      maxHeightDiskCache: 400,
      maxWidthDiskCache: 600,

      // Optimized image builder to prevent layout issues
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },

      // Consistent loading indicator
      progressIndicatorBuilder: (context, url, progress) {
        return Container(
          color: CupertinoColors.systemGrey6,
          child: Center(
            child: progress.totalSize != null
                ? CircularProgressIndicator(
                    value: progress.downloaded / progress.totalSize!,
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      CupertinoColors.activeBlue,
                    ),
                  )
                : const CupertinoActivityIndicator(),
          ),
        );
      },

      // Error widget with consistent sizing
      errorWidget: (context, url, error) {
        return Container(
          color: CupertinoColors.systemGrey6,
          child: const Center(
            child: Icon(
              CupertinoIcons.exclamationmark_triangle,
              color: CupertinoColors.systemRed,
              size: 32,
            ),
          ),
        );
      },
    );
  }
}
