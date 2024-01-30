import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/main/review/request/review_body.dart';
import 'package:watchlistfy/models/main/review/request/update_review_body.dart';
import 'package:watchlistfy/models/main/review/review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/main/review/spoiler_switch.dart';
import 'package:http/http.dart' as http;

class ReviewCreatePage extends StatelessWidget {
  final Review? review;
  final String contentID;
  final String? contentExternalID;
  final int? contentExternalIntID;
  final String contentType;
  final VoidCallback _fetchData;
  final VoidCallback? updateReviewData;

  const ReviewCreatePage(
    this.contentID, this.contentExternalID, 
    this.contentExternalIntID, this.contentType,
    this._fetchData,
    {this.review, this.updateReviewData, super.key}
  );

  void handleReviewOperation(BuildContext context, String review, int star, bool isSpoiler, bool isUpdating) async {
    if (review.isNotEmpty && review.length < 6) {
      showCupertinoDialog(context: context, builder: (_) => const ErrorDialog("Invalid review. Your review can not be empty!"));
      return;
    }
    
    showCupertinoDialog(context: context, builder: (_) => const LoadingDialog());

    final ReviewBody reviewBody = ReviewBody(
      contentID, contentExternalID, contentExternalIntID, contentType,
      isSpoiler, star, review,
    );

    final UpdateReviewBody updateReviewBody = UpdateReviewBody(
      this.review?.id ?? '', isSpoiler, star, review
    );
    
    try {
      final response = isUpdating 
      ? await http.patch(
        Uri.parse(APIRoutes().reviewRoutes.updateReview),
        body: json.encode(updateReviewBody.convertToJson()),
        headers: UserToken().getBearerToken()
      )
      : await http.post(
        Uri.parse(APIRoutes().reviewRoutes.createReview),
        body: json.encode(reviewBody.convertToJson()),
        headers: UserToken().getBearerToken()
      );
      
      if (context.mounted) {
        Navigator.pop(context);

        var baseMessage = response.getBaseMessageResponse();

        if (baseMessage.error != null && context.mounted){
          showCupertinoDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.getBaseMessageResponse().error!)
          ); 
          return;
        }

        if (context.mounted) {
          Navigator.pop(context);
        
          showCupertinoDialog(
            context: context, 
            builder: (ctx) => MessageDialog(baseMessage.message ?? "Unkwown error!")
          );

          _fetchData();
          if (updateReviewData != null) {
            updateReviewData!();
          }
        }
      }
    } catch(error) {
      if (context.mounted) {
        showCupertinoDialog(
          context: context, 
          builder: (ctx) => ErrorDialog(error.toString())
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: review?.review);
    final spoilerSwitch = SpoilerSwitch(isSpoiler: review?.isSpoiler ?? false);
    int rating = review?.star ?? 3;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(review != null ? "Update Review" : "Post a Review"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: rating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                unratedColor: CupertinoTheme.of(context).bgTextColor,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                itemBuilder: (context, _) => const Icon(
                  CupertinoIcons.star_fill,
                  color: CupertinoColors.systemYellow,
                ),
                onRatingUpdate: (rate) {
                  rating = rate.toInt();
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: CupertinoTextField(
                  maxLength: 1000,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  controller: controller,
                  placeholder: "Write your review here...",
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: BoxDecoration(
                    color: CupertinoTheme.of(context).onBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              spoilerSwitch,
              const SizedBox(height: 32),
              CupertinoButton.filled(
                child: Text(review != null ? "Update" : "Post", style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)), 
                onPressed: () {
                  if (review != null) {
                    handleReviewOperation(context, controller.text, rating, spoilerSwitch.isSpoiler, true);
                  } else {
                    handleReviewOperation(context, controller.text, rating, spoilerSwitch.isSpoiler, false);
                  }
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}