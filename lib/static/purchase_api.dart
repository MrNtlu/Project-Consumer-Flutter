import 'dart:convert';
import 'dart:io';
import 'package:watchlistfy/models/auth/basic_user_info.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:http/http.dart' as http;

// ignore_for_file: avoid_init_to_null
class PurchaseApi {
  BasicUserInfo? userInfo = null;

  PurchaseApi._privateConstructor();

  static final PurchaseApi _instance = PurchaseApi._privateConstructor();

  factory PurchaseApi() {
    return _instance;
  }

  Future setUserInfo() async {
    await http.get(
      Uri.parse(APIRoutes().userRoutes.basic),
      headers: UserToken().getBearerToken()
    ).then((response) async {
      userInfo = response.getBaseItemResponse<BasicUserInfo>().data;
      if (userInfo != null) {
        await Purchases.logIn(userInfo!.email);
      }
    });
  }

  Future setUserMembershipStatus(bool isPremium, int membershipType) async {
    await http.patch(
      Uri.parse(APIRoutes().userRoutes.changeMembership),
      headers: UserToken().getBearerToken(),
      body: json.encode({
        "is_premium": isPremium,
        "membership_type": membershipType
      })
    );
  }

  Future checkUserPremiumStatus() async {
    final purchaserInfo = await Purchases.getCustomerInfo();
    final entitlements = purchaserInfo.entitlements.active.values.toList();

    if (
      userInfo != null
      && (entitlements.isEmpty || (entitlements.isNotEmpty && !entitlements.first.isActive))
      && userInfo!.isPremium
    ) {
      await setUserMembershipStatus(false, 0);
      await setUserInfo();
    } else if (
      userInfo != null
      && (entitlements.isNotEmpty && entitlements.first.isActive)
      && !userInfo!.isPremium
    ) {
      await setUserMembershipStatus(true, (entitlements.first.productIdentifier == "watchlistfy_premium_1mo" || entitlements.first.productIdentifier == "watchlistfy_premium_1mo:monthly-autorenewing") ? 1 : 2);
      await setUserInfo();
    }
  }

  Future init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    final configuration = PurchasesConfiguration(Platform.isIOS ? dotenv.env['REVENUE_CAT_IOS_KEY'] ?? '': dotenv.env['REVENUE_CAT_ANDROID_KEY'] ?? '');
    await Purchases.configure(configuration);
  }

  Future userInit() async {
    await setUserInfo();
    await checkUserPremiumStatus();

    Purchases.addCustomerInfoUpdateListener((purchaserInfo) async {
      await checkUserPremiumStatus();
    });
  }

  Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      return current == null ? [] : [current];
    } on PlatformException catch (_) {
      return [];
    }
  }
}