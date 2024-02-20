import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/sure_dialog.dart';
import 'package:watchlistfy/widgets/main/profile/custom_list_entry_cell.dart';

class CustomListDetailsPage extends StatelessWidget {
  final CustomList item;
  final Future<BaseMessageResponse> Function(String, CustomList) deleteCustomList;

  const CustomListDetailsPage(this.item, this.deleteCustomList, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(item.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
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
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
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
                                return MovieDetailsPage(content.contentID);
                              case ContentType.tv:
                                return TVDetailsPage(content.contentID);
                              case ContentType.anime:
                                return AnimeDetailsPage(content.contentID);
                              case ContentType.game: 
                                return GameDetailsPage(content.contentID);
                            }
                          }, maintainState: false)
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
                  const Icon(CupertinoIcons.heart_fill, size: 20),
                  const SizedBox(width: 3),
                  Text(item.popularity.toString()),
                  const SizedBox(width: 12),
                  const Icon(CupertinoIcons.bookmark_fill, size: 20),
                  const SizedBox(width: 3),
                  Text(item.bookmarkCount.toString()),
                  const Spacer(),
                  CupertinoButton(
                    onPressed: () {
                      showCupertinoDialog(
                        context: context, 
                        builder: (_) {
                          return SureDialog("Do you want to delete it?", () {
                            Navigator.pop(context);
                  
                            showCupertinoDialog(
                              context: context,
                              builder: (_) {
                                return const LoadingDialog();
                              }
                            );
                  
                            deleteCustomList(
                              item.id,
                              item
                            ).then((value) {
                              Navigator.pop(context);
                  
                              showCupertinoDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  if (value.error != null) {
                                    return ErrorDialog(value.error!);
                                  } else {
                                    return MessageDialog(value.message ?? "Successfully deleted.");
                                  }
                                }
                              );
                            });
                          });
                        }
                      );
                    },
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.delete,
                    )
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}
