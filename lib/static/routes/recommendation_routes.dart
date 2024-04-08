class RecommendationRoutes {
  late String _baseRecommendationRoute;

  late String recommendationByContent;
  late String likedRecommendation;
  late String createRecommendation;
  late String deleteRecommendation;
  // late String updateRecommendation;
  late String recommendationsByUserID;
  late String recommendationListSocial;
  late String likeRecommendation;

  RecommendationRoutes({baseURL}) {
    _baseRecommendationRoute = '$baseURL/recommendation';

    recommendationByContent = _baseRecommendationRoute;
    createRecommendation = _baseRecommendationRoute;
    deleteRecommendation = _baseRecommendationRoute;
    recommendationsByUserID = '$_baseRecommendationRoute/profile';
    likeRecommendation = '$_baseRecommendationRoute/like';
    recommendationListSocial = '$_baseRecommendationRoute/social';
    likedRecommendation = '$_baseRecommendationRoute/liked';
    // updateRecommendation = _baseRecommendationRoute;
  }
}