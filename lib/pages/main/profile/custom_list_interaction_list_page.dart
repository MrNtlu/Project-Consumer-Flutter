import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_share_details_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/profile/custom_list_interaction_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/empty_view.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/profile/custom_list_sort_sheet.dart';

class CustomListInteractionListPage extends StatefulWidget {
  final bool isBookmark;
  const CustomListInteractionListPage({this.isBookmark = true, super.key});

  @override
  State<CustomListInteractionListPage> createState() => _CustomListInteractionListPageState();
}

class _CustomListInteractionListPageState extends State<CustomListInteractionListPage> {
  ListState _state = ListState.init;
  String? _error;

  late final CustomListInteractionProvider _provider;
  late final AuthenticationProvider _authProvider;

  void _fetchData() {
    setState(() {
      _state = ListState.loading;
    });

    Future<BaseListResponse<CustomList>> fetchData;
    if (widget.isBookmark) {
      fetchData = _provider.getBookmarkedCustomLists();
    } else {
      fetchData = _provider.getLikedCustomLists();
    }

    fetchData.then((response) {
      _error = response.error;

      if (_state != ListState.disposed) {
        setState(() {
          _state = _error != null
            ? ListState.error
            : (
              response.data.isEmpty
                ? ListState.empty
                : ListState.done
            );
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _authProvider = Provider.of<AuthenticationProvider>(context);
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = CustomListInteractionProvider();
    if (_state != ListState.init) {
      _fetchData();
    }
  }

  @override
  void dispose() {
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _provider,
      child: Consumer<CustomListInteractionProvider>(
        builder: (context, provider, child) {
      
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text("🗂️ ${widget.isBookmark ? 'Bookmarked' : 'Liked'} Lists"),
              trailing: CupertinoButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context, 
                    builder: (context) {
                      return CustomListSortSheet(_provider.sort, (newSort) {{
                        final shouldFetchData = _provider.sort != newSort;
                        _provider.sort = newSort;

                        if (shouldFetchData) {
                          _fetchData(); 
                        }
                      }});
                    }
                  );
                },
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.sort_down,
                  size: 28
                )
              ),
            ),
            child: _body(provider.items),
          );
        }
      ),
    );
  }

  Widget _body(List<CustomList> data) {
    switch (_state) {
      case ListState.done:
        
        return ListView.builder(
          itemCount: data.isEmpty ? 1 : data.length,
          itemBuilder: (context, index) {
            if (data.isEmpty) {
              return const EmptyView("assets/lottie/list.json", "You don't have anything here.");
            }

            final content = data[index];
            final sortedContent = content.content.sorted((a, b) => a.order.compareTo(b.order));

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(builder: (_) {
                    return CustomListShareDetailsPage(content.id);
                  })
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            content.name,
                            minFontSize: 14,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ),
                        Text(
                          DateTime.parse(content.createdAt).dateToHumanDate(),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          content.isPrivate ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill, size: 18,
                          color: CupertinoTheme.of(context).bgTextColor,
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 75,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sortedContent.length,
                              itemBuilder: (context, index) {
                                final listContent = sortedContent[index];
                                
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3),
                                  child: ContentCell(listContent.imageURL ?? '', listContent.titleEn, cornerRadius: 8),
                                );
                              }
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Row(
                          children: [
                            if (!widget.isBookmark)
                            CupertinoButton(
                              onPressed: () async {
                                if (_authProvider.isAuthenticated) {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (_) {
                                      return const LoadingDialog();
                                    }
                                  );
                    
                                  _provider.likeCustomList(content.id, content).then((value) {
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
                              child: Icon(content.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, size: 22),
                            ),
                            if (!widget.isBookmark)
                            Text(content.popularity.toString()),
                            if (!widget.isBookmark)
                            const SizedBox(width: 12),
                            if (widget.isBookmark)
                            CupertinoButton(
                              onPressed: () async {
                                if (_authProvider.isAuthenticated) {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (_) {
                                      return const LoadingDialog();
                                    }
                                  );
                    
                                  _provider.bookmarkCustomList(content.id, content).then((value) {
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
                              child: Icon(content.isBookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark, size: 22),
                            ),
                            if (widget.isBookmark)
                            Text(content.popularity.toString()),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
      case ListState.empty:
        return const EmptyView("assets/lottie/list.json", "You don't have anything here.");
      case ListState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_error ?? "Unknown error!"),
          ),
        );
      default:
       return const LoadingView("Loading");
    }
  }
}