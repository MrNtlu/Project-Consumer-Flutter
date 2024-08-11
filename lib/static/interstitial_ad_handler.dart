import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdHandler {
  InterstitialAd? interstitialAd;

  final interstitialTestAdUnitId = Platform.isIOS
    ? 'ca-app-pub-3940256099942544/4411468910'
    : 'ca-app-pub-3940256099942544/1033173712';

  void showAds() {
    interstitialAd?.show();
    loadAds();
  }

  void loadAds() {
    InterstitialAd.load(
      adUnitId: kDebugMode
      ? interstitialTestAdUnitId
      : Platform.isIOS
        ? dotenv.env['ADMOB_INT_IOS_KEY'] ?? ''
        : dotenv.env['ADMOB_INT_ANDROID_KEY'] ?? '',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          interstitialAd?.dispose();
        },
      )
    );
  }

  InterstitialAdHandler._privateConstructor();

  static final InterstitialAdHandler _instance =
      InterstitialAdHandler._privateConstructor();

  factory InterstitialAdHandler() {
    return _instance;
  }
}
