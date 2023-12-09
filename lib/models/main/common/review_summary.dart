class ReviewSummary {
  //TODO Review?
  final double averageStar;
  final int totalVotes;
  final bool isReviewed;
  final StarCounts starCounts;

  ReviewSummary(
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
