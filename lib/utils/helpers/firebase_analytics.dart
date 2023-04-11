import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:jetwallet/core/services/device_info/models/device_info_model.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';

Future<void> checkInitAppFBAnalytics(
  LocalStorageService storage,
  String deviceUid,
) async {
  final firstInitAppStorage = await storage.getValue(firstInitAppCodeKey);
  final referralCode = await storage.getValue(referralCodeKey);

  if (firstInitAppStorage == null) {
    await FirebaseAnalytics.instance.logEvent(
      name: 'first_initialize_app',
      parameters: {
        'device_id': deviceUid,
        'referral_code': referralCode ?? '',
      },
    );

    await storage.setString(firstInitAppCodeKey, 'true');
  }
}
