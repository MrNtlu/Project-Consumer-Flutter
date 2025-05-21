import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:watchlistfy/pages/main/image_page.dart';

class DetailsCarouselSlider extends StatelessWidget {
  final List<String> images;

  const DetailsCarouselSlider(this.images, {super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(builder: (_) {
                    return ImagePage(i);
                  })
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: i,
                    key: ValueKey<String>(i),
                    cacheKey: i,
                    fit: BoxFit.cover,
                    cacheManager: CustomCacheManager(),
                    maxHeightDiskCache: 300,
                    maxWidthDiskCache: 400, // Added
                  )
                )
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 250,
        aspectRatio: 16/9,
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
      )
    );
  }
}