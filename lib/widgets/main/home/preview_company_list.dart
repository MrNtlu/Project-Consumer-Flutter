import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/tv_discover_list_page.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';

class PreviewCompanyList extends StatelessWidget {
  final bool isMovie;
  const PreviewCompanyList({required this.isMovie, super.key});

  @override
  Widget build(BuildContext context) {
    final PreviewProvider previewProvider = Provider.of<PreviewProvider>(context);

    return SizedBox(
      height: 75,
      child: previewProvider.networkState == NetworkState.success
      ? ListView.builder(
        itemCount: (isMovie
          ? previewProvider.moviePreview.productionCompanies
          : previewProvider.tvPreview.productionCompanies)!.length,
        scrollDirection: Axis.horizontal,
        itemExtent: 150,
        itemBuilder: (context, index) {
          final company = (isMovie
          ? previewProvider.moviePreview.productionCompanies
          : previewProvider.tvPreview.productionCompanies)![index];

          return Padding(
            padding: index == 0 ? const EdgeInsets.only(left: 8, right: 4) : const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(builder: (_) {
                    if (isMovie) {
                      return MovieDiscoverListPage(productionCompanies: Uri.encodeQueryComponent(company.name));
                    } else {
                      return TVDiscoverListPage(productionCompanies: Uri.encodeQueryComponent(company.name));
                    }
                  })
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ColoredBox(
                  color: CupertinoColors.white,
                  child: CachedNetworkImage(
                    imageUrl: company.logo,
                    cacheKey: company.logo,
                    key: ValueKey<String>(company.logo),
                    maxHeightDiskCache: 200,
                    maxWidthDiskCache: 275,
                    errorListener: (_) {},
                    progressIndicatorBuilder: (_, __, ___) => const SizedBox(
                      height: 75,
                      width: 150,
                      child: ColoredBox(
                        color: CupertinoColors.systemGrey2
                      ),
                    ),
                    fadeInDuration: const Duration(milliseconds: 0),
                    fadeOutDuration: const Duration(milliseconds: 0),
                  ),
                ),
              ),
            ),
          );
        }
      )
    : ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          15,
          (index) => Padding(
            padding: index == 0 ? const EdgeInsets.only(left: 8, right: 4) : const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              width: 150,
              height: 75,
              child: Shimmer.fromColors(
                baseColor: CupertinoColors.systemGrey,
                highlightColor: CupertinoColors.systemGrey3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ColoredBox(
                    color: CupertinoColors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: const ColoredBox(color: CupertinoColors.systemGrey),
                    ),
                  ),
                )
              ),
            ),
          )
        )
      ),
    );
  }
}