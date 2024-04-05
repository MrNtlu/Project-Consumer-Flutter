class BasicUserInfo {
  final String id;
  String fcmToken;
  final bool isOAuth;
  final bool isPremium;
  final int membershipType;
  final int? oAuthType;
  final bool canChangeUsername;
  final Notification appNotification;
  final Notification mailNotification;
  final String email;
  String? image;
  final String username;
  final int streak;
  final int userListCount;
  final int consumeLaterCount;
  final String createdAt;

  BasicUserInfo(
    this.id, this.fcmToken, this.isOAuth,
    this.isPremium, this.membershipType,
    this.oAuthType, this.canChangeUsername,
    this.appNotification, this.mailNotification,
    this.email, this.image, this.username, this.streak,
    this.userListCount, this.consumeLaterCount, this.createdAt,
  );
}

class Notification {
  bool promotions;
  bool updates;
  bool follows;
  bool reviewLikes;

  Notification(
    this.promotions,
    this.updates,
    this.follows,
    this.reviewLikes
  );
}