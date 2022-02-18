import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/device_info.dart';
import '../model/device_info/device_info_model.dart';

final _deviceInfoFpod = FutureProvider<DeviceInfoModel>(
  (ref) {
    return deviceInfo();
  },
  name: 'deviceInfoFpod',
);

/// Initialize at the start of the app
final deviceInfoPod = Provider<DeviceInfoModel>(
  (ref) {
    DeviceInfoModel? info;

    ref.watch(_deviceInfoFpod).whenData((value) {
      info = value;
    });

    return info ?? const DeviceInfoModel();
  },
  name: 'deviceInfoPod',
);
