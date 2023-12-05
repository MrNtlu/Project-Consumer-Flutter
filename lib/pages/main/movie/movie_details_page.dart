import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/providers/main/movie/movie_details_provider.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';

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
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(_provider.item?.title ?? ""),
        ),
        child: SafeArea(
          child: _provider.isLoading
          ? const LoadingView("Please wait")
          : Column(
            children: [
              Text(_provider.item?.title ?? ''),
              CupertinoButton(
                child: Text(
                  _provider.item?.consumeLater != null
                  ? "Remove Bookmark"
                  : "Bookmark"
                ), 
                onPressed: () {
                  if (_provider.item?.consumeLater != null) {
                    _provider.deleteConsumeLaterObject(IDBody(widget.id)).then((response) {
                      print("Delete response ${response.message} ${response.error}");
                    });
                  } else if (_provider.item != null) {
                    final item = _provider.item!;
                    
                    print("Provider create called");

                    _provider.createConsumeLaterObject(
                      ConsumeLaterBody(item.id, item.tmdbID, "movie")
                    ).then((response) {
                      print("Create response ${response.message} ${response.error}");
                    });
                  }
                }
              )
            ],
          )
        ),
      )
    );
  }
}
