import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/device_uid.dart';

final _deviceUidFpod = FutureProvider<String?>(
  (ref) {
    return deviceUid();
  },
  name: 'deviceUidFpod',
);

/// Initialize at the start of the app
final deviceUidPod = Provider<String>(
  (ref) {
    var uid = '';

    ref.watch(_deviceUidFpod).whenData((value) {
      uid = value ?? '';
    });

    return uid;
  },
  name: 'deviceUidPod',
);
