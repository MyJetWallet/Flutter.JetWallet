import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/apps_flyer_service.dart';
import '../services/remote_config_service/remote_config_values.dart';

final appsFlyerServicePod = Provider<AppsFlyerService>(
  (ref) {
    return AppsFlyerService.create(
      devKey: appsFlyerKey,
      iosAppId: iosAppId,
    );
  },
  name: 'appsFlyerServicePod',
);
