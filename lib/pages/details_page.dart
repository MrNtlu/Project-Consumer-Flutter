import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/movie/movie_details_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/unauthorized_dialog.dart';
import 'package:watchlistfy/widgets/common/user_list_view_sheet.dart';
import 'package:watchlistfy/widgets/main/common/details_navigation_bar.dart';
import 'package:watchlistfy/widgets/main/movie/movie_watch_list_sheet.dart';

class DetailsPage extends StatelessWidget {
  final String id;
  final ContentType contentType;

  const DetailsPage({
    super.key,
    required this.id,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ChangeNotifierProvider(
        create: (_) => MovieDetailsProvider(),
        child: Consumer2<MovieDetailsProvider, AuthenticationProvider>(
          builder: (
            context,
            movieDetailsProvider,
            authProvider,
            child,
          ) {
            return CustomScrollView(
              slivers: [
                DetailsNavigationBar(
                  movieDetailsProvider.item?.title.isNotEmpty == true
                      ? movieDetailsProvider.item!.title
                      : movieDetailsProvider.item?.titleOriginal ?? '',
                  "movie",
                  movieDetailsProvider.item == null,
                  movieDetailsProvider.item?.userList == null,
                  movieDetailsProvider.item?.consumeLater == null,
                  movieDetailsProvider.isUserListLoading,
                  movieDetailsProvider.isLoading,
                  onBookmarkTap: () {
                    if (!movieDetailsProvider.isLoading &&
                        authProvider.isAuthenticated) {
                      final item = movieDetailsProvider.item;

                      if (item != null && item.consumeLater != null) {
                        movieDetailsProvider
                            .deleteConsumeLaterObject(
                          IDBody(
                            item.consumeLater!.id,
                          ),
                        )
                            .then(
                          (
                            response,
                          ) {
                            if (response.error != null && context.mounted) {
                              showCupertinoDialog(
                                context: context,
                                builder: (_) => ErrorDialog(response.error!),
                              );
                            }
                          },
                        );
                      } else if (item != null) {
                        movieDetailsProvider
                            .createConsumeLaterObject(
                          ConsumeLaterBody(
                            item.id,
                            item.tmdbID,
                            "movie",
                          ),
                        )
                            .then(
                          (response) {
                            if (response.error != null && context.mounted) {
                              showCupertinoDialog(
                                context: context,
                                builder: (_) => ErrorDialog(response.error!),
                              );
                            }
                          },
                        );
                      }
                    } else if (!authProvider.isAuthenticated) {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const UnauthorizedDialog(),
                      );
                    }
                  },
                  onListTap: () {
                    if (!movieDetailsProvider.isUserListLoading &&
                        authProvider.isAuthenticated) {
                      final item = movieDetailsProvider.item;

                      if (item != null && item.userList != null) {
                        final status = Constants.UserListStatus.firstWhere(
                            (element) =>
                                element.request == item.userList!.status).name;
                        final score = item.userList!.score ?? 'Not Scored';
                        final timesFinished = item.userList!.timesFinished;

                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return UserListViewSheet(
                                movieDetailsProvider.item!.id,
                                movieDetailsProvider.item!.title,
                                "🎯 $status\n⭐ $score\n🏁 $timesFinished time(s)",
                                movieDetailsProvider.item!.userList!,
                                externalID: movieDetailsProvider.item!.tmdbID,
                                contentType: ContentType.movie,
                                movieProvider: movieDetailsProvider,
                              );
                            });
                      } else if (item != null) {
                        showCupertinoModalPopup(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return MovieWatchListSheet(
                                movieDetailsProvider,
                                movieDetailsProvider.item!.id,
                                movieDetailsProvider.item!.tmdbID);
                          },
                        );
                      }
                    } else if (!authProvider.isAuthenticated) {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const UnauthorizedDialog(),
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _body({
    required DetailState state,
    String? error,
    required VoidCallback fetchData,
  }) {
    switch (state) {
      case DetailState.init:
        return const SizedBox.shrink();
      case DetailState.view:
        return const SizedBox.shrink();
      case DetailState.error:
        return SliverFillRemaining(
            child: ErrorView(error ?? "Unknown error", fetchData));
      case DetailState.loading:
        return const SliverFillRemaining(child: LoadingView("Loading"));
      default:
        return const SliverFillRemaining(child: LoadingView("Loading"));
    }
  }
}
