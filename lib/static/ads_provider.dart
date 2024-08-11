class AdsTracker {
  int clickCount = 0;

  void incrementCount() {
    if (clickCount == 14) {
      clickCount = 0;
    } else {
      clickCount ++;
    }
  }

  bool shouldShowAds() {
    final shouldShow = clickCount % 15 == 0;
    incrementCount();
    return shouldShow;
  }

  AdsTracker._privateConstructor();

  static final AdsTracker _instance =
      AdsTracker._privateConstructor();

  factory AdsTracker() {
    return _instance;
  }
}
