import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/main/common/review_summary.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/widgets/common/unauthorized_dialog.dart';

class DetailsReviewSummary extends StatelessWidget {
  final ReviewSummary reviewSummary;

  const DetailsReviewSummary(this.reviewSummary, {super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 32, 12, 8),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          reviewSummary.averageStar.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const Icon(Icons.star_rounded, color: CupertinoColors.systemYellow,)
                      ],
                    ),
                    const SizedBox(height: 3),
                    AutoSizeText(
                      "${reviewSummary.totalVotes} Reviews", 
                      minFontSize: 11,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13, 
                        color: CupertinoColors.systemGrey2
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _progressCell(context, "5", reviewSummary.starCounts.fiveStar > 0 ? reviewSummary.starCounts.fiveStar / reviewSummary.totalVotes : 0),
                    _progressCell(context, "4", reviewSummary.starCounts.fourStar > 0 ? reviewSummary.starCounts.fourStar / reviewSummary.totalVotes : 0),
                    _progressCell(context, "3", reviewSummary.starCounts.threeStar > 0 ? reviewSummary.starCounts.threeStar / reviewSummary.totalVotes : 0),
                    _progressCell(context, "2", reviewSummary.starCounts.twoStar > 0 ? reviewSummary.starCounts.twoStar / reviewSummary.totalVotes : 0),
                    _progressCell(context, "1", reviewSummary.starCounts.oneStar > 0 ? reviewSummary.starCounts.oneStar / reviewSummary.totalVotes : 0),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: CupertinoButton.filled(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, size: 18, color: CupertinoColors.white,),
                  const SizedBox(width: 8),
                  Text(
                    reviewSummary.isReviewed ? "Edit Review" : "Write a Review",
                    style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ],
              ),
              onPressed: () {
                if (!authProvider.isAuthenticated) {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) => const UnauthorizedDialog()
                  );
                } else if (reviewSummary.isReviewed) {
                  
                } else {
            
                }
              }
            ),
          )
        ],
      ),
    );
  }

  Widget _progressCell(BuildContext context, String label, double value) => Row(
    children: [
      SizedBox(
        width: 15,
        child: Text(label)
      ),
      const SizedBox(width: 6),
      Expanded(
        child: LinearProgressIndicator(
          minHeight: 6,
          borderRadius: BorderRadius.circular(8),
          color: CupertinoColors.systemYellow,
          value: value,
        ),
      )
    ],
  );
}