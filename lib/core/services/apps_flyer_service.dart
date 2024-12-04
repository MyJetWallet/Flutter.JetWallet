import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';

class AppsFlyerService {
  AppsFlyerService.create({
    required String devKey,
    required String iosAppId,
    required String androidAppId,
  }) {
    if (kIsWeb) {
      return;
    }
    final options = AppsFlyerOptions(
      afDevKey: devKey,
      appId: Platform.isIOS ? iosAppId : androidAppId,
      disableCollectASA: false,
      disableAdvertisingIdentifier: false,
      timeToWaitForATTUserAuthorization: 60,
    );

    appsflyerSdk = AppsflyerSdk(options);
  }

  final LocalStorageService storage = sLocalStorageService;

  late AppsflyerSdk appsflyerSdk;

  String installConversionDataTemp = '';

  Future<void> init() async {
    if (kIsWeb) {
      return;
    }

    await appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    appsflyerSdk.addPushNotificationDeepLinkPath(['af_push']);

    appsflyerSdk.onInstallConversionData((value) async {
      installConversionDataTemp = value.toString();
      final prevInstallConversionData = await storage.getValue(installConversionDataKey);
      if (prevInstallConversionData == null || prevInstallConversionData.isEmpty) {
        await storage.setString(installConversionDataKey, value.toString());
      }

      try {
        if (value is Map<String, dynamic>) {
          if (value['status'] == 'success') {
            final data = value['payload'] as Map<String, dynamic>;

            final afStatus = (data['af_status'] as String?) ?? '';

            if (afStatus != 'Organic') {
              final mediaSource = (data['media_source'] as String?) ?? 'mediaSourceError';
              final campaign = (data['campaign'] as String?) ?? 'campaignError';

              await storage.setString(
                mediaSourceKey,
                mediaSource,
              );

              await storage.setString(
                campaignKey,
                campaign,
              );

              final deepLinkValue = data['deep_link_value'] as String?;

              if (deepLinkValue != null) {
                if (deepLinkValue.contains('ReferralRedirect')) {
                  try {
                    final temp = deepLinkValue.split('jw_code/');
                    if (temp.length > 1) {
                      final referralCode = temp[1];
                      await storage.setString(referralCodeKey, referralCode);
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print('[AppsFlyerService] ReferralRedirect error: $e');
                    }
                  }
                } else {
                  await getIt.get<DeepLinkService>().handleOneLinkAction(deepLinkValue);
                }
              }
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('[AppsFlyerService] OnInstallConversionData Error: $e');
        }
      }
    });

    appsflyerSdk.onDeepLinking((deepLink) {
      storage.setJson(onelinkDataKey, deepLink.toJson());

      if (deepLink.deepLink?.deepLinkValue != null) {
        getIt.get<DeepLinkService>().handleOneLinkAction(deepLink.deepLink!.deepLinkValue!);
      }
    });
  }

  Future<void> updateServerUninstallToken() async {
    if (kIsWeb) {
      return;
    }

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      appsflyerSdk.updateServerUninstallToken(token);
    }
  }
}
