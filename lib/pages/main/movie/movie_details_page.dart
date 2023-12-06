import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/providers/main/movie/movie_details_provider.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
            // navigationBar: CupertinoNavigationBar(
            //   middle: ,
            // ),
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
                        child: Icon(
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

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.star_fill, color: CupertinoColors.systemYellow,),
                    const SizedBox(width: 3),
                    Text(item.tmdbVote.toStringAsFixed(2), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(
                  height: 125,
                  child: ContentCell(item.imageUrl, item.title)
                )
              ],
            )
          ],
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
