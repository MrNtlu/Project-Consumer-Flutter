import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/pages/main/image_page.dart';

class DetailsCarouselSlider extends StatefulWidget {
  final List<String> images;

  const DetailsCarouselSlider(this.images, {super.key});

  @override
  State<DetailsCarouselSlider> createState() => _DetailsCarouselSliderState();
}

class _DetailsCarouselSliderState extends State<DetailsCarouselSlider> {
  late final CarouselSliderController _carouselController;
  late final CupertinoThemeData _theme;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = CupertinoTheme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    return Column(
      children: [
        _buildCarousel(width),
        const SizedBox(height: 16),
        _buildImageIndicators(),
      ],
    );
  }

  Widget _buildCarousel(double width) {
    return CarouselSlider(
      carouselController: _carouselController,
      items: widget.images.asMap().entries.map(
        (entry) {
          final index = entry.key;
          final imageUrl = entry.value;

          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () => _navigateToImagePage(imageUrl, index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: width,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Hero(
                    tag: 'carousel_image_$index',
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: _OptimizedCarouselImage(
                              imageUrl: imageUrl,
                              cacheKey: 'carousel_${imageUrl.hashCode}',
                              theme: _theme,
                            ),
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
        height: 260,
        aspectRatio: 16 / 9,
        viewportFraction: 0.85,
        initialPage: 0,
        enableInfiniteScroll: widget.images.length > 1,
        reverse: false,
        autoPlay: widget.images.length > 1,
        autoPlayInterval: const Duration(seconds: 6),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        autoPlayCurve: Curves.easeInOutCubic,
        enlargeCenterPage: true,
        enlargeFactor: 0.15,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildImageIndicators() {
    if (widget.images.length <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.images.asMap().entries.map((entry) {
        final index = entry.key;
        final isActive = index == _currentIndex;

        return GestureDetector(
          onTap: () => _carouselController.animateToPage(
            index,
            duration: const Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeInOut,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isActive ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isActive
                  ? AppColors().primaryColor
                  : _theme.bgTextColor.withValues(alpha: 0.3),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors().primaryColor.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _navigateToImagePage(String imageUrl, int index) {
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
  }
}

class _OptimizedCarouselImage extends StatelessWidget {
  final String imageUrl;
  final String cacheKey;
  final CupertinoThemeData theme;

  const _OptimizedCarouselImage({
    required this.imageUrl,
    required this.cacheKey,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl.replaceFirst("original", "w780"),
      key: ValueKey<String>(cacheKey),
      cacheKey: cacheKey,
      fit: BoxFit.cover,
      cacheManager: CustomCacheManager(),
      maxHeightDiskCache: 520,
      maxWidthDiskCache: 780,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  CupertinoColors.black.withValues(alpha: 0.1),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        );
      },
      progressIndicatorBuilder: (context, url, progress) {
        return Container(
          decoration: BoxDecoration(
            color: theme.onBgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                progress.totalSize != null
                    ? CircularProgressIndicator(
                        value: progress.downloaded / progress.totalSize!,
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors().primaryColor,
                        ),
                        backgroundColor:
                            theme.bgTextColor.withValues(alpha: 0.2),
                      )
                    : CupertinoActivityIndicator(
                        color: AppColors().primaryColor,
                      ),
                const SizedBox(height: 12),
                Text(
                  "Loading image...",
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.bgTextColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          decoration: BoxDecoration(
            color: theme.onBgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.photo,
                  color: theme.bgTextColor.withValues(alpha: 0.5),
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  "Image unavailable",
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.bgTextColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
