import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/common/request/delete_user_list_body.dart';
import 'package:watchlistfy/providers/main/anime/anime_details_provider.dart';
import 'package:watchlistfy/providers/main/game/game_details_provider.dart';
import 'package:watchlistfy/providers/main/movie/movie_details_provider.dart';
import 'package:watchlistfy/providers/main/tv/tv_details_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/sure_dialog.dart';
import 'package:watchlistfy/widgets/main/anime/anime_watch_list_sheet.dart';
import 'package:watchlistfy/widgets/main/game/game_details_play_list_sheet.dart';
import 'package:watchlistfy/widgets/main/movie/movie_watch_list_sheet.dart';
import 'package:watchlistfy/widgets/main/tv/tv_watch_list_sheet.dart';

class UserListViewSheet extends StatelessWidget {
  final MovieDetailsProvider? movieProvider;
  final TVDetailsProvider? tvProvider;
  final AnimeDetailsProvider? animeProvider;
  final GameDetailsProvider? gameProvider;
  final String contentID;
  final String? externalID;
  final int? externalIntID;
  final ContentType contentType;

  final String title;
  final String message;
  final int? episodePrefix;
  final int? seasonPrefix;
  final BaseUserList userList;

  const UserListViewSheet(
    this.contentID, this.title,
    this.message, this.userList, {
      this.externalID,
      this.externalIntID,
      this.episodePrefix,
      this.seasonPrefix,
      required this.contentType,
      this.movieProvider,
      this.tvProvider,
      this.animeProvider,
      this.gameProvider,
      super.key
    }
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(title),
      message: Text(
        message,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 16,
          color: CupertinoTheme.of(context).bgTextColor,
        ),
      ),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Close', style: TextStyle(color: CupertinoColors.systemBlue)),
      ),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);

            switch (contentType) {
              case ContentType.movie:
                showCupertinoModalPopup(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return MovieWatchListSheet(movieProvider!, contentID, externalID!, userList: userList);
                  }
                );
                break;
              case ContentType.tv:
                showCupertinoModalPopup(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return TVWatchListSheet(tvProvider!, contentID, externalID!, userList: userList, episodePrefix: episodePrefix, seasonPrefix: seasonPrefix);
                  }
                );
              case ContentType.anime:
                showCupertinoModalPopup(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AnimeWatchListSheet(animeProvider!, contentID, externalIntID!, userList: userList, episodePrefix: episodePrefix);
                  }
                );
              case ContentType.game:
                showCupertinoModalPopup(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return GameDetailsPlayListSheet(gameProvider!, contentID, externalIntID!, userList: userList);
                  }
                );
              default:
                break;
            }
          },
          child: const Text('Change', style: TextStyle(color: CupertinoColors.activeBlue)),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (_) {
                return SureDialog("Do you want to remove it from your list?", () {
                  Navigator.pop(context);

                  switch (contentType) {
                    case ContentType.movie:
                      movieProvider!.deleteMovieWatchList(DeleteUserListBody(userList.id, contentType.request));
                      break;
                    case ContentType.tv:
                      tvProvider!.deleteTVWatchList(DeleteUserListBody(userList.id, contentType.request));
                      break;
                    case ContentType.anime:
                      animeProvider!.deleteAnimeWatchList(DeleteUserListBody(userList.id, contentType.request));
                      break;
                    case ContentType.game:
                      gameProvider!.deleteGamePlayList(DeleteUserListBody(userList.id, contentType.request));
                      break;
                    default:
                      break;
                  }
                });
              }
            );
          },
          child: const Text('Remove'),
        ),
      ],
    );
  }
}
