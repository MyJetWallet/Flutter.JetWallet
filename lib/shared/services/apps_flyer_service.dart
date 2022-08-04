import 'dart:convert';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AppsFlyerService {
  AppsFlyerService.create({
    required this.devKey,
    required this.iosAppId,
  }) {
    final options = AppsFlyerOptions(
      afDevKey: devKey,
      appId: iosAppId,
      disableAdvertisingIdentifier: true,
      timeToWaitForATTUserAuthorization: 30,
    );

    appsflyerSdk = AppsflyerSdk(options);
  }

  final String devKey;
  final String iosAppId;

  late AppsflyerSdk appsflyerSdk;

  Future<void> init() async {
    await appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
  }

  void startSession(String source, String email, String appsFlyerId) {
    final bytes = utf8.encode(email);
    final hashEmail = sha256.convert(bytes).toString();
    appsflyerSdk.logEvent('Start Session', {
      'Customer User iD': hashEmail,
      'Appsflyer ID': appsFlyerId,
      'Registration/Login/SSO': source,
    });
  }

  Future<void> updateServerUninstallToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      appsflyerSdk.updateServerUninstallToken(token);
    }
  }
}
