import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/providers/main/profile/custom_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';

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
              trailing: CupertinoButton(
                onPressed: () {
                  //TODO Redirect to create page
                  // Navigator.of(context, rootNavigator: true).push(
                  //   CupertinoPageRoute(builder: (_) {
                  //     return const CustomListPage();
                  //   })
                  // ).then();
                },
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.add,
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
              return _emptyView();
            }

            final content = data[index];

            return GestureDetector(
              onTap: () {

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
                    SizedBox(
                      height: 75,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: content.content.length,
                        itemBuilder: (context, index) {
                          final listContent = content.content[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: ContentCell(listContent.imageURL ?? '', listContent.titleEn, cornerRadius: 8),
                          );
                        }
                      ),
                    )
                  ],
                ),
              ),
            );
          }
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
            frameRate: FrameRate(60)
          ),
          const Text("Nothing here. You can create a new list.", style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );
}