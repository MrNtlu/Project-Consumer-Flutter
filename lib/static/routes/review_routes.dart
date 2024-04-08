class ReviewRoutes {
  late String _baseReviewRoute;

  late String review;
  late String getSelfReviews;
  late String likedReview;
  late String createReview;
  late String deleteReview;
  late String updateReview;
  late String reviewsByUser;
  late String reviewDetails;
  late String reviewListSocial;
  late String voteReview;

  ReviewRoutes({baseURL}) {
    _baseReviewRoute = '$baseURL/review';

    review = _baseReviewRoute;
    getSelfReviews = '$_baseReviewRoute/profile';
    likedReview = '$_baseReviewRoute/liked';
    createReview = _baseReviewRoute;
    deleteReview = _baseReviewRoute;
    updateReview = _baseReviewRoute;
    reviewsByUser = '$_baseReviewRoute/user';
    reviewDetails = '$_baseReviewRoute/details';
    voteReview = '$_baseReviewRoute/like';
    reviewListSocial = '$_baseReviewRoute/social';
  }
}
