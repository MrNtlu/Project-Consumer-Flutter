class RefreshRateHelper {
  double? _refreshRate;

  RefreshRateHelper._privateConstructor();

  static final RefreshRateHelper _instance =
      RefreshRateHelper._privateConstructor();

  factory RefreshRateHelper() {
    return _instance;
  }

  void setRefreshRate(double refreshRate) {
    _refreshRate = refreshRate;
  }

  double getRefreshRate() => _refreshRate ?? 60;
}
