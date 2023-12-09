import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/providers/main/movie/movie_details_provider.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:watchlistfy/widgets/main/common/details_character_list.dart';
import 'package:watchlistfy/widgets/main/common/details_info_column.dart';
import 'package:watchlistfy/widgets/main/common/details_main_info.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';

class MovieDetailsPage extends StatefulWidget {
  final String id;

  const MovieDetailsPage(this.id, {super.key});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  DetailState _state = DetailState.init;

  late final MovieDetailsProvider _provider;
  String? _error;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getMovieDetails(widget.id).then((response) {
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
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = MovieDetailsProvider();
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
      child: Consumer<MovieDetailsProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: AutoSizeText(
                    _provider.item?.title ?? "",
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: provider.item != null
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (!provider.isLoading) {
                            
                          }
                        },
                        child: Icon(
                          provider.item!.watchList != null
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (!provider.isLoading) {
                            final item = provider.item;
      
                            if (item != null && item.consumeLater != null) {
                              provider.deleteConsumeLaterObject(IDBody(item.consumeLater!.id)).then((response) {
                                if (response.error != null) {
                                  showCupertinoDialog(
                                    context: context, 
                                    builder: (_) => ErrorDialog(response.error!),
                                  );
                                }
                              });
                            } else if (item != null) {
                              provider.createConsumeLaterObject(
                                ConsumeLaterBody(item.id, item.tmdbID, "movie")
                              ).then((response) {
                                if (response.error != null) {
                                  showCupertinoDialog(
                                    context: context, 
                                    builder: (_) => ErrorDialog(response.error!),
                                  );
                                }
                              });
                            }
                          }
                        },
                        child: provider.isLoading 
                        ? const CupertinoActivityIndicator() 
                        : Icon(
                          provider.item!.consumeLater != null
                          ? CupertinoIcons.bookmark_fill
                          : CupertinoIcons.bookmark
                        ),
                      ),
                    ],
                  )
                  : null,
                ),
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _body(provider),
                  ),
                )
              ],
            ),
          );
        } 
      )
    );
  }

  Widget _body(MovieDetailsProvider provider) {
    switch (_state) {
      case DetailState.view:
        final item = provider.item!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: item.title != item.titleOriginal ? 142 : 125,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            DetailsMainInfo(
                              item.tmdbVote.toStringAsFixed(2),
                              item.status,
                            ),
                            DetailsInfoColumn(
                              item.title != item.titleOriginal,
                              item.titleOriginal,
                              item.length.toLength(),
                              DateTime.parse(item.releaseDate).dateToHumanDate()
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 125,
                    child: ContentCell(item.imageUrl, item.title)
                  ),
                ],
              ),
              const SizedBox(height: 16,),
              const CustomDivider(height: 0.75),
              const DetailsTitle("Genres"),
              Text(
                item.genres.join(", "),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const DetailsTitle("Description"),
              ExpandableText(
                item.description,
                maxLines: 3,
                expandText: "Read More",
                collapseText: "Read Less",
                linkColor: CupertinoColors.systemBlue,
                style: const TextStyle(fontSize: 16),
                linkStyle: const TextStyle(fontSize: 14),
              ),
              const DetailsTitle("Actors"),
              SizedBox(
                height: 110,
                child: DetailsCharacterList(
                  item.actors.length,
                  (index) {
                    return item.actors[index].image;
                  },
                  (index) {
                    return item.actors[index].name;
                  },
                  (index) {
                    return item.actors[index].character;
                  },
                )
              ),
              const DetailsTitle("Recommendations"),
            ],
          ),
        );
      case DetailState.error:
        return ErrorView(_error ?? "Unknown error", _fetchData);
      case DetailState.loading:
        return const LoadingView("Please wait");
      default:
        return const LoadingView("Loading");
    }
  }
}
