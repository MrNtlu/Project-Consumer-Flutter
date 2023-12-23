import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/main/movie/movie_details_provider.dart';

class DetailsNavigationBar extends StatelessWidget {
  final VoidCallback onBookmarkTap;
  final VoidCallback onListTap;

  const DetailsNavigationBar({required this.onBookmarkTap, required this.onListTap, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieDetailsProvider>(context);

    return CupertinoSliverNavigationBar(
      largeTitle: AutoSizeText(
        provider.item?.title ?? "",
        style: const TextStyle(fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: provider.item != null
      ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onListTap,
            child: Icon(
              provider.item!.userList != null
              ? CupertinoIcons.heart_fill
              : CupertinoIcons.heart
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onBookmarkTap,
            child: Icon(
              provider.item!.consumeLater != null
              ? CupertinoIcons.bookmark_fill
              : CupertinoIcons.bookmark
            ),
          ),
        ],
      )
      : null,
    );
  }
}