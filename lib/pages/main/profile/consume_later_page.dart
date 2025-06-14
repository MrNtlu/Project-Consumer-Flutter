import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/consume_later_response.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/profile/consume_later_provider.dart';
import 'package:watchlistfy/providers/main/profile/consume_later_sort_filter_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/refresh_rate_helper.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/notification_overlay.dart';
import 'package:watchlistfy/widgets/common/sure_dialog.dart';
import 'package:watchlistfy/widgets/main/profile/consume_later_action_sheet.dart';
import 'package:watchlistfy/widgets/main/profile/consume_later_grid_cell.dart';
import 'package:watchlistfy/widgets/main/profile/consume_later_sort_filter_sheet.dart';

class ConsumeLaterPage extends StatefulWidget {
  const ConsumeLaterPage({super.key});

  @override
  State<ConsumeLaterPage> createState() => _ConsumeLaterPageState();
}

class _ConsumeLaterPageState extends State<ConsumeLaterPage> {
  ListState _state = ListState.init;
  String? _error;

  late final ConsumeLaterProvider _provider;
  late final GlobalProvider _globalProvider;
  late final ConsumeLaterSortFilterProvider _sortFilterProvider;
  late final CupertinoThemeData cupertinoTheme;

  void _fetchData() {
    setState(() {
      _state = ListState.loading;
    });

    _provider
        .getConsumeLater(
      _sortFilterProvider.filterContent?.request,
      _sortFilterProvider.sort,
      _sortFilterProvider.genre,
      _sortFilterProvider.streaming,
    )
        .then((response) {
      _error = response.error;

      if (_state != ListState.disposed) {
        setState(() {
          _state = _error != null
              ? ListState.error
              : (response.data.isEmpty ? ListState.empty : ListState.done);
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        Navigator.pop(context);
      }

      _globalProvider = Provider.of<GlobalProvider>(context);
      cupertinoTheme = CupertinoTheme.of(context);
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = ConsumeLaterProvider();
    _sortFilterProvider = ConsumeLaterSortFilterProvider();
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _provider),
        ChangeNotifierProvider(create: (_) => _sortFilterProvider),
      ],
      child: Consumer2<ConsumeLaterProvider, ConsumeLaterSortFilterProvider>(
        builder: (context, provider, sortFilterProvider, child) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("🕒 Watch Later"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                      onPressed: () {
                        _globalProvider.setConsumeLaterMode(
                            _globalProvider.consumeLaterMode ==
                                    Constants.ConsumeLaterUIModes.first
                                ? Constants.ConsumeLaterUIModes.last
                                : Constants.ConsumeLaterUIModes.first);
                      },
                      padding: EdgeInsets.zero,
                      child: Icon(
                          _globalProvider.consumeLaterMode ==
                                  Constants.ConsumeLaterUIModes.first
                              ? Icons.grid_view_rounded
                              : CupertinoIcons.list_bullet,
                          size: 28)),
                  CupertinoButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                            context: context,
                            expand: true,
                            builder: (context) {
                              return ConsumeLaterSortFilterSheet(
                                  _fetchData, sortFilterProvider);
                            });
                      },
                      padding: EdgeInsets.zero,
                      child: const Icon(Icons.filter_alt_rounded, size: 28))
                ],
              ),
            ),
            child: RefreshIndicator(
                backgroundColor: cupertinoTheme.bgTextColor,
                color: cupertinoTheme.bgColor,
                onRefresh: () async {
                  if (_state == ListState.done || _state == ListState.error) {
                    _fetchData();
                  }
                },
                child: _body(provider.items)),
          );
        },
      ),
    );
  }

  Widget _body(List<ConsumeLaterResponse> data) {
    switch (_state) {
      case ListState.done:
        final isGridView = _globalProvider.consumeLaterMode ==
            Constants.ConsumeLaterUIModes.first;

        return isGridView
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GridView.builder(
                    itemCount: data.isEmpty ? 1 : data.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6),
                    itemBuilder: (context, index) {
                      if (data.isEmpty) {
                        return SizedBox(
                          height: 150,
                          child: _emptyView(),
                        );
                      }

                      final content = data[index];
                      final contentType = ContentType.values
                          .where((element) =>
                              content.contentType == element.request)
                          .first;

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (_) {
                                return DetailsPage(
                                  id: content.contentID,
                                  contentType: contentType,
                                );
                              },
                            ),
                          );
                        },
                        child: ConsumeLaterGridCell(
                            content.content.imageUrl, content.content.titleEn,
                            () {
                          showCupertinoDialog(
                              context: context,
                              builder: (_) {
                                return SureDialog("Do you want to remove it?",
                                    () {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (_) {
                                        return const LoadingDialog();
                                      });

                                  _provider
                                      .deleteConsumeLater(content.id, content)
                                      .then((value) {
                                    if (value.error != null &&
                                        value.error == "Could not found.") {
                                      Navigator.pop(context);
                                      _provider.removeItem(content);
                                    } else {
                                      handleMessageResponse(context, value);
                                    }
                                  });
                                });
                              });
                        }, () {
                          showCupertinoDialog(
                              context: context,
                              builder: (_) {
                                return SureDialog(
                                    "Do you want to mark it as finished and add to your list?",
                                    () {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (_) {
                                        return const LoadingDialog();
                                      });

                                  //TODO Implement score later
                                  _provider
                                      .moveToUserList(
                                    content.id,
                                    null,
                                    content,
                                  )
                                      .then((value) {
                                    if (value.error != null &&
                                        value.error == "Could not found.") {
                                      Navigator.pop(context);
                                      _provider.removeItem(content);
                                    } else {
                                      handleMessageResponse(context, value);
                                    }
                                  });
                                });
                              });
                        }),
                      );
                    }),
              )
            : ListView.builder(
                itemCount: data.isEmpty ? 1 : data.length,
                itemBuilder: (context, index) {
                  if (data.isEmpty) {
                    return _emptyView();
                  }

                  final content = data[index];
                  final contentType = ContentType.values
                      .where(
                          (element) => content.contentType == element.request)
                      .first;

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (_) {
                            return DetailsPage(
                              id: content.contentID,
                              contentType: contentType,
                            );
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 6, right: 3, top: 4, bottom: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 135,
                            child: ContentCell(
                              content.content.imageUrl
                                  .replaceFirst("original", "w400"),
                              content.content.titleEn,
                              cornerRadius: 8,
                              forceRatio: true,
                              cacheHeight: 375,
                              cacheWidth: 300,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              content.content.titleEn.isNotEmpty
                                                  ? content.content.titleEn
                                                  : content
                                                      .content.titleOriginal,
                                              minFontSize: 14,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              wrapWords: true,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            AutoSizeText(
                                              content.content.titleOriginal,
                                              minFontSize: 12,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color:
                                                    CupertinoColors.systemGrey2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        child: const Icon(
                                          CupertinoIcons.ellipsis_vertical,
                                        ),
                                        onPressed: () {
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (_) {
                                              return ConsumeLaterActionSheet(
                                                index,
                                                content.id,
                                                content.content.titleEn
                                                        .isNotEmpty
                                                    ? content.content.titleEn
                                                    : content
                                                        .content.titleOriginal,
                                                contentType,
                                                _provider,
                                                content,
                                                () {
                                                  showCupertinoDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return const LoadingDialog();
                                                      });

                                                  //TODO Implement score later
                                                  _provider
                                                      .moveToUserList(
                                                    content.id,
                                                    null,
                                                    content,
                                                  )
                                                      .then(
                                                    (value) {
                                                      handleMessageResponse(
                                                          context, value);
                                                    },
                                                  );
                                                },
                                                () {
                                                  showCupertinoDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return const LoadingDialog();
                                                    },
                                                  );

                                                  _provider
                                                      .deleteConsumeLater(
                                                          content.id, content)
                                                      .then(
                                                    (value) {
                                                      handleMessageResponse(
                                                        context,
                                                        value,
                                                      );
                                                    },
                                                  );
                                                },
                                                () {
                                                  Navigator.of(
                                                    context,
                                                    rootNavigator: true,
                                                  ).push(
                                                    CupertinoPageRoute(
                                                      builder: (_) {
                                                        return DetailsPage(
                                                          id: content.contentID,
                                                          contentType:
                                                              contentType,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(
                                      content.contentType == "game"
                                          ? content.content.description
                                              .removeAllHtmlTags()
                                          : content.content.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(CupertinoIcons.star_fill,
                                          color: CupertinoColors.systemYellow,
                                          size: 14),
                                      const SizedBox(width: 3),
                                      Text(
                                        content.content.score
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      CupertinoChip(
                                        isSelected: true,
                                        onSelected: null,
                                        label: contentType.value,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "Created at ${DateTime.parse(content.createdAt).dateToHumanDate()}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: CupertinoColors.systemGrey2,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
      case ListState.empty:
        return _emptyView();
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

  Widget _emptyView() => Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                "assets/lottie/discover.json",
                height: 128,
                width: 128,
                frameRate: FrameRate(
                  RefreshRateHelper().getRefreshRate(),
                ),
              ),
              const Text(
                "Nothing here.",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );

  void handleMessageResponse(BuildContext context, BaseMessageResponse value) {
    Navigator.pop(context);

    if (value.error != null) {
      showCupertinoDialog(
        context: context,
        builder: (context) => ErrorDialog(value.error!),
      );
    } else {
      NotificationOverlay().show(
        context,
        title: "Success",
        message: value.message ?? "Successfully moved.",
      );
    }
  }
}
