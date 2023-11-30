import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class PreviewList extends StatefulWidget {
  const PreviewList({super.key});

  @override
  State<PreviewList> createState() => _PreviewListState();
}

class _PreviewListState extends State<PreviewList> {
  late final PreviewProvider _previewProvider;

  @override
  void didChangeDependencies() {
    _previewProvider = Provider.of<PreviewProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _previewProvider.networkState != NetworkState.success
      ? ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const ContentCell("https://image.tmdb.org/t/p/original/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg"),
        ],
      )
      : CircularProgressIndicator();
  }
}
