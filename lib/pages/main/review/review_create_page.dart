import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/main/review/review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:watchlistfy/static/colors.dart';

class ReviewCreatePage extends StatelessWidget {
  final Review? review;
  // final String contentID;
  // final String? contentExternalID;
  // final int? contentExternalIntID;
  // final String contentType;

  const ReviewCreatePage({this.review, super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(review != null ? "Update Review" : "Create Review"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: 3,
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
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: CupertinoTextField(
                  maxLength: 1000,
                  maxLines: null,
                  minLines: null,
                  expands: true,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoSwitch(
                    activeColor: CupertinoTheme.of(context).bgTextColor,
                    thumbColor: AppColors().primaryColor,
                    value: true,//widget._value,
                    onChanged: (value) {
                      // setState(() {
                      //   widget._value = !widget._value;
                      // });
                    },
                  ),
                  const Text("Contains Spoiler", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
                ],
              ),
              const SizedBox(height: 32),
              CupertinoButton.filled(
                child: Text(review != null ? "Update" : "Post", style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)), 
                onPressed: () {

                }
              )
            ],
          ),
        ),
      ),
    );
  }
}