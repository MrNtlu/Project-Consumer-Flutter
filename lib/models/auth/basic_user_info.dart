class BasicUserInfo {
  final String id;
  String fcmToken;
  final bool isOAuth;
  final bool isPremium;
  final int membershipType;
  final int? oAuthType;
  final bool canChangeUsername;
  final Notification appNotification;
  final String email;
  String? image;
  final String username;
  final int streak;
  final String createdAt;

  BasicUserInfo(
    this.id, this.fcmToken, this.isOAuth,
    this.isPremium, this.membershipType,
    this.oAuthType, this.canChangeUsername,
    this.appNotification, this.email, this.image,
    this.username, this.streak, this.createdAt,
  );
}

class Notification {
  bool friendRequest;
  bool reviewLikes;

  Notification(this.friendRequest, this.reviewLikes);
}
