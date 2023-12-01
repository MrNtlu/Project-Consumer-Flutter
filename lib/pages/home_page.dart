import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/common/name_url.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/home/anonymous_header.dart';
import 'package:watchlistfy/widgets/main/home/loggedin_header.dart';
import 'package:watchlistfy/widgets/main/home/preview_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});  

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(context);
    final previewProvider = Provider.of<PreviewProvider>(context, listen: false);

    var genreSize = switch (previewProvider.selectedContentType) {
      ContentType.movie => Constants.MovieGenreList.length,
      ContentType.anime => Constants.AnimeGenreList.length,
      ContentType.tv => Constants.TVGenreList.length,
      ContentType.game => Constants.GameGenreList.length,
    };

    Provider.of<PreviewProvider>(context, listen: false).getPreviews();

    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: authenticationProvider.isAuthenticated
                  ?  const LoggedinHeader()
                  : const AnonymousHeader()
                ),
                CupertinoButton(
                  child: Row(
                    children: [
                      Text(
                        "Movie",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: CupertinoTheme.of(context).bgTextColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        CupertinoIcons.arrowtriangle_down_circle_fill,
                        size: 13,
                        color: CupertinoTheme.of(context).bgTextColor,
                      )
                    ],
                  ), 
                  onPressed: () {

                  }
                )
              ],
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSearchTextField(
                keyboardType: TextInputType.name,
              ),
            ),
            const SizedBox(height: 8),
            _previewTitle("🔥 Popular"),
            SizedBox(
              height: 200,
              child: PreviewList(Constants.CONTENT_TAGS[0])
            ),
            const SizedBox(height: 24),
            SizedBox(
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            _previewTitle("📆 Upcoming"),
            SizedBox(
              height: 200,
              child: PreviewList(Constants.CONTENT_TAGS[1])
            ),
            const SizedBox(height: 8),
            _previewTitle("❤️ Top Rated"),
            SizedBox(
              height: 200,
              child: PreviewList(Constants.CONTENT_TAGS[2])
            ),
            const SizedBox(height: 8),
            _previewTitle("🎭 In Theaters"),
            SizedBox(
              height: 200,
              child: PreviewList(Constants.CONTENT_TAGS[3])
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _previewTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: GestureDetector(
      onTap: () {

      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
          const Icon(CupertinoIcons.chevron_right)
        ],
      ),
    ),
  );
}