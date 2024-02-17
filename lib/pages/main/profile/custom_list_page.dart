import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_create_page.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_details_page.dart';
import 'package:watchlistfy/providers/main/profile/custom_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/empty_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/profile/custom_list_action_sheet.dart';
import 'package:watchlistfy/widgets/main/profile/custom_list_sort_sheet.dart';

class CustomListPage extends StatefulWidget {
  const CustomListPage({super.key});

  @override
  State<CustomListPage> createState() => _CustomListPageState();
}

class _CustomListPageState extends State<CustomListPage> {
  ListState _state = ListState.init;
  String? _error;

  late final CustomListProvider _provider;

  void _fetchData() {
    setState(() {
      _state = ListState.loading;
    });

    _provider.getCustomLists().then((response) {
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
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = CustomListProvider();
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
      child: Consumer<CustomListProvider>(
        builder: (context, provider, child) {
      
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("🗂️ Custom Lists"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context, 
                        builder: (context) {
                          return CustomListSortSheet(_provider.sort, (newSort) {
                            final shouldFetchData = _provider.sort != newSort;
                            _provider.sort = newSort;

                            if (shouldFetchData) {
                              _fetchData(); 
                            }
                          });
                        }
                      );
                    },
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.sort_down,
                      size: 28
                    )
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(builder: (_) {
                          return CustomListCreatePage(_fetchData);
                        })
                      );
                    },
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.add,
                      size: 28
                    )
                  ),
                ],
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
              return const EmptyView("assets/lottie/empty.json", "Nothing here. You can create a new list.");
            }

            final content = data[index];
            final sortedContent = content.content.sorted((a, b) => a.order.compareTo(b.order));

            return GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(builder: (_) {
                    return CustomListDetailsPage(content, _provider.deleteCustomList);
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
                                  child: ContentCell(listContent.imageURL ?? '', listContent.titleEn, cornerRadius: 8, forceRatio: true),
                                );
                              }
                            ),
                          ),
                        ),
                        CupertinoButton(
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context, 
                              builder: (_) {
                                return CustomListActionSheet(content, _provider.deleteCustomList, _fetchData);
                              }
                            );
                          },
                          child: const Icon(CupertinoIcons.ellipsis_vertical)
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        );
      case ListState.empty:
        return const EmptyView("assets/lottie/empty.json", "Nothing here. You can create a new list.");
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