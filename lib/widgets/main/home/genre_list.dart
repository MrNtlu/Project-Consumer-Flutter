import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/common/name_url.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/constants.dart';

class GenreList extends StatelessWidget {
  const GenreList({super.key});

  @override
  Widget build(BuildContext context) {
    final previewProvider = Provider.of<PreviewProvider>(context);

    var genreSize = switch (previewProvider.selectedContentType) {
      ContentType.movie => Constants.MovieGenreList.length,
      ContentType.anime => Constants.AnimeGenreList.length,
      ContentType.tv => Constants.TVGenreList.length,
      ContentType.game => Constants.GameGenreList.length,
    };

    return SizedBox(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genreSize,
        itemBuilder: (context, index) {
          List<NameUrl> genreList;

          switch (previewProvider.selectedContentType) {
            case ContentType.movie:
              genreList = Constants.MovieGenreList;
              break;
            case ContentType.tv:
              genreList = Constants.TVGenreList;
              break;
            case ContentType.anime:
              genreList = Constants.AnimeGenreList;
              break;
            case ContentType.game:
              genreList = Constants.GameGenreList;
              break;
            default:
              genreList = Constants.MovieGenreList;
              break;
          }

          final data = genreList[index];
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    data.url
                  ),
                  ColoredBox(
                    color: CupertinoColors.black.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                        child: Text(
                        data.name,
                        style: const TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: CupertinoColors.white
                        ),
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}