import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'camera_permission_notifier.dart';
import 'camera_permission_state.dart';

final cameraPermissionNotipod = StateNotifierProvider.autoDispose<
    CameraPermissionNotifier, CameraPermissionState>(
  (ref) {
    return CameraPermissionNotifier(ref.read);
  },
  name: 'cameraPermissionNotipod',
);
