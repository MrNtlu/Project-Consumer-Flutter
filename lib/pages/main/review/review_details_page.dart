import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/review/review.dart';
import 'package:watchlistfy/pages/main/profile/profile_display_page.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';

class ReviewDetailsPage extends StatefulWidget {
  final Review item;
  final Future<BaseMessageResponse> Function(String) likeReview;

  const ReviewDetailsPage(this.item, this.likeReview, {super.key});

  @override
  State<ReviewDetailsPage> createState() => _ReviewDetailsPageState();
}

class _ReviewDetailsPageState extends State<ReviewDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("💬 ${widget.item.author.username}'s Review"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(builder: (_) {
                          return ProfileDisplayPage(widget.item.author.username);
                        })
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Uri.tryParse(widget.item.author.image) != null
                            ? CachedNetworkImage(
                              imageUrl: widget.item.author.image,
                              height: 40,
                              width: 40,
                              key: ValueKey<String>(widget.item.author.image),
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (_, __, ___) => const Padding(padding: EdgeInsets.all(3), child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 40,
                                color: CupertinoColors.activeBlue,
                              ),
                            )
                            : const Icon(
                              Icons.person,
                              size: 40,
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.author.username,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              DateTime.parse(widget.item.createdAt).dateToHumanDate(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.systemGrey2
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.item.star.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    CupertinoIcons.star_fill,
                    color: CupertinoColors.systemYellow,
                    size: 15,
                  )
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.item.review,
                    style: TextStyle(fontSize: 15, color: CupertinoTheme.of(context).bgTextColor),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CupertinoButton(
                    onPressed: () async {
                      showCupertinoDialog(
                        context: context,
                        builder: (_) {
                          return const LoadingDialog();
                        }
                      );
        
                      widget.likeReview(widget.item.id).then((value) {
                        if (context.mounted) {
                          Navigator.pop(context);
        
                          if (value.error != null) {
                            showCupertinoDialog(
                              context: context,
                              builder: (_) {
                                return ErrorDialog(value.error ?? value.message ?? "Unknown error!");
                              }
                            );
                          } else {
                            setState(() {
                              widget.item.isLiked = !widget.item.isLiked;
                              widget.item.popularity = widget.item.popularity + (widget.item.isLiked ? 1 : -1); 
                            });
                          }
                        }
                      });
                    },
                    minSize: 0,
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    child: Icon(widget.item.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, size: 20),
                  ),
                  Text(widget.item.popularity.toString()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
