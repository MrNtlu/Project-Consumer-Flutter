import 'package:watchlistfy/models/main/review/review.dart';

class ReviewSummary {
  final Review? review;
  final double averageStar;
  final int totalVotes;
  final bool isReviewed;
  final StarCounts starCounts;

  ReviewSummary(
    this.review,
    this.averageStar,
    this.totalVotes,
    this.isReviewed,
    this.starCounts,
  );
}

class StarCounts {
  final int oneStar;
  final int twoStar;
  final int threeStar;
  final int fourStar;
  final int fiveStar;

  StarCounts(
    this.oneStar, this.twoStar, this.threeStar, 
    this.fourStar, this.fiveStar,
  );
}
