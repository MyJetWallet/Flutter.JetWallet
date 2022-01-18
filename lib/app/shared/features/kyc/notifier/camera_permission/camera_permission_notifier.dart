import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/services/local_storage_service.dart';
import 'camera_permission_state.dart';

class CameraPermissionNotifier extends StateNotifier<CameraPermissionState> {
    CameraPermissionNotifier(
    this.read,
  ) : super(const CameraPermissionState());


  final Reader read;

  Future<bool> checkCameraStatus() async {
    final storage = read(localStorageServicePod);
    final status = await storage.getString(cameraStatusKey);

    if (status == null) {
      // First time
      final status = await Permission.camera.request();
      final newStatus = await Permission.camera.status;

      if (newStatus == PermissionStatus.granted) {
        return true;
      }

      if (status == PermissionStatus.denied) {
        await storage.setString(cameraStatusKey, 'denied');
        state = state.copyWith(cameraStatus: CameraStatus.denied);
        return false;
      }
    } else if (status == CameraStatus.denied.name) {
      await openAppSettings();
    } else {
      return true;
    }
    return false;
  }
}
