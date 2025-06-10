class AdsTracker {
  int clickCount = 0;

  void incrementCount() {
    if (clickCount == 10) {
      clickCount = 0;
    } else {
      clickCount++;
    }
  }

  bool shouldShowAds() {
    final shouldShow = clickCount % 10 == 2;
    incrementCount();
    return shouldShow;
  }

  AdsTracker._privateConstructor();

  static final AdsTracker _instance = AdsTracker._privateConstructor();

  factory AdsTracker() {
    return _instance;
  }
}
