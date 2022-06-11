import 'package:firebase_analytics/firebase_analytics.dart';

import '../model/device_info/device_info_model.dart';
import '../services/local_storage_service.dart';

Future<void> checkInitAppFBAnalytics(
  LocalStorageService storage,
  DeviceInfoModel deviceInfo,
) async {
  final firstInitAppStorage = await storage.getValue(firstInitAppCodeKey);
  final referralCode = await storage.getValue(referralCodeKey);

  if (firstInitAppStorage == null) {
    await FirebaseAnalytics.instance.logEvent(
      name: 'first_initialize_app',
      parameters: {
        'device_id': deviceInfo.deviceUid,
        'referral_code': referralCode ?? '',
      },
    );

    await storage.setString(firstInitAppCodeKey, 'true');
  }
}
