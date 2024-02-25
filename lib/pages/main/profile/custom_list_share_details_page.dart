import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_display_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/profile/custom_list_share_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/main/common/author_info_row.dart';
import 'package:watchlistfy/widgets/main/profile/custom_list_entry_cell.dart';

class CustomListShareDetailsPage extends StatefulWidget {
  final String id;

  const CustomListShareDetailsPage(this.id, {super.key});

  @override
  State<CustomListShareDetailsPage> createState() => _CustomListShareDetailsPageState();
}

class _CustomListShareDetailsPageState extends State<CustomListShareDetailsPage> {
  DetailState _state = DetailState.init;

  late final CustomListShareProvider _provider;
  late final AuthenticationProvider _authProvider;
  String? _error;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getCustomListDetails(id: widget.id).then((response) {
      _error = response.error;

      if (_state != DetailState.disposed) {
        setState(() {
          _state = response.error != null
            ? DetailState.error
            : (
              response.data != null
                ? DetailState.view
                : DetailState.error
            );
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      _authProvider = Provider.of<AuthenticationProvider>(context);
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = CustomListShareProvider();
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _provider,
      child: Consumer<CustomListShareProvider>(
        builder: (context, provider, child) {
          final item = provider.item;

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(item?.name ?? "Custom List"),
              trailing: item != null
              ? CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              minSize: 0,
              child: const Icon(CupertinoIcons.share),
              onPressed: () async {
                final url = '${Constants.BASE_DOMAIN_URL}/custom-list/${item.id}';

                try {
                  final box = context.findRenderObject() as RenderBox?;

                  if (box != null) {
                    Share.share(
                      url,
                      subject: 'Share ${item.name}',
                      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
                    );
                  }
                } catch (_) {
                  await Clipboard.setData(ClipboardData(text: url));
                  if (context.mounted) {
                    showCupertinoDialog(context: context, builder: (_) => const MessageDialog("Copied to clipboard."));
                  }
                }
              }
            ) : null,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: _body(provider),
              )
            ),
          );
        }
      )
    );
  }

  Widget _body(CustomListShareProvider provider) {
    switch (_state) {
      case DetailState.view:
        final item = provider.item!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.description != null && item.description!.isNotEmpty)
            const Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
            if (item.description != null && item.description!.isNotEmpty)
            const SizedBox(height: 8),
            if (item.description != null && item.description!.isNotEmpty)
            Text(
              item.description!,
            ),
            if (item.description != null && item.description!.isNotEmpty)
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: item.content.isNotEmpty ? item.content.length : 1,
                itemBuilder: (context, index) {
                  if (item.content.isEmpty) {
                    return const SizedBox(
                      height: 150,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("No entry yet."),
                        ),
                      ),
                    );
                  }

                  final content = item.content.sorted((a, b) => a.order.compareTo(b.order))[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(builder: (_) {
                          switch (ContentType.values.where((element) => element.request == content.contentType).first) {
                            case ContentType.movie:
                              return MovieDetailsPage(content.contentID.isNotEmpty ? content.contentID : content.contentExternalID ?? '');
                            case ContentType.tv:
                              return TVDetailsPage(content.contentID.isNotEmpty ? content.contentID : content.contentExternalID ?? '');
                            case ContentType.anime:
                              return AnimeDetailsPage(content.contentID.isNotEmpty ? content.contentID : content.contentExternalIntID?.toString() ?? '');
                            case ContentType.game:
                              return GameDetailsPage(content.contentID.isNotEmpty ? content.contentID : content.contentExternalIntID?.toString() ?? '');
                          }
                        })
                      );
                    },
                    child: CustomListEntryCell(
                      index: index + 1,
                      contentType: ContentType.values.where((element) => content.contentType == element.request).first.value,
                      null,
                      BaseContent(
                        content.contentID,
                        "",
                        content.imageURL ?? '',
                        content.titleEn.isNotEmpty ? content.titleEn : content.titleOriginal,
                        content.titleOriginal.isNotEmpty ? content.titleOriginal : content.titleEn,
                        content.contentExternalID,
                        content.contentExternalIntID
                      ),
                      true,
                      null,
                      null,
                      key: ValueKey(content.contentID),
                    ),
                  );
                }
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CupertinoButton(
                  onPressed: () async {
                    if (_authProvider.isAuthenticated) {
                      showCupertinoDialog(
                        context: context,
                        builder: (_) {
                          return const LoadingDialog();
                        }
                      );

                      provider.likeCustomList(widget.id).then((value) {
                        if (context.mounted) {
                          Navigator.pop(context);

                          if (value.error != null) {
                            showCupertinoDialog(
                              context: context,
                              builder: (_) {
                                return ErrorDialog(value.error ?? value.message ?? "Unknown error!");
                              }
                            );
                          }
                        }
                      });
                    } else {
                      showCupertinoDialog(
                        context: context,
                        builder: (_) => const ErrorDialog("You need to login to do this action.")
                      );
                    }
                  },
                  minSize: 0,
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  child: Icon(item.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, size: 22),
                ),
                Text(item.popularity.toString()),
                const SizedBox(width: 12),
                CupertinoButton(
                  onPressed: () async {
                    if (_authProvider.isAuthenticated) {
                      showCupertinoDialog(
                        context: context,
                        builder: (_) {
                          return const LoadingDialog();
                        }
                      );

                      provider.bookmarkCustomList(widget.id).then((value) {
                        if (context.mounted) {
                          Navigator.pop(context);

                          if (value.error != null) {
                            showCupertinoDialog(
                              context: context,
                              builder: (_) {
                                return ErrorDialog(value.error ?? value.message ?? "Unknown error!");
                              }
                            );
                          }
                        }
                      });
                    } else {
                      showCupertinoDialog(
                        context: context,
                        builder: (_) => const ErrorDialog("You need to login to do this action.")
                      );
                    }
                  },
                  minSize: 0,
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  child: Icon(item.isBookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark, size: 22),
                ),
                Text(item.bookmarkCount.toString()),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(builder: (_) {
                        return ProfileDisplayPage(item.author.username);
                      })
                    );
                  },
                  child: AuthorInfoRow(item.author),
                )
              ],
            )
          ],
        );
      case DetailState.error:
        return ErrorView(_error ?? "Unknown error", _fetchData);
      case DetailState.loading:
        return const LoadingView("Loading");
      default:
        return const LoadingView("Loading");
    }
  }
}