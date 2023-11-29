class BasicUserInfo {
  String fcmToken;
  final bool isOAuth;
  final bool isPremium;
  final int membershipType;
  final int? oAuthType;
  final bool canChangeUsername;
  final Notification appNotification;
  final String email;
  final String? image;
  final String username;

  BasicUserInfo(
    this.fcmToken, this.isOAuth, this.isPremium,
    this.membershipType, this.oAuthType, this.canChangeUsername,
    this.appNotification, this.email, this.image, this.username,
  );
}

class Notification {
  bool friendRequest;
  bool reviewLikes;

  Notification(this.friendRequest, this.reviewLikes);
}
