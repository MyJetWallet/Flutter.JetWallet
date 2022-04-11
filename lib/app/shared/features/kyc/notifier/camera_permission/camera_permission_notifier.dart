import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/services/local_storage_service.dart';
import '../../view/components/upload_documents/upload_kyc_documents.dart';
import 'camera_permission_state.dart';

/// If camera permission is granted, this notifier never won't be used
/// So, we are making an assumption that CameraStatus can be either undefined
/// or denied. CameraStatus is undefined if app haven't triggered permission
/// request yet. If permission request was triggered at least once, then when
/// we are on this screen this means that permission was denied.
class CameraPermissionNotifier extends StateNotifier<CameraPermissionState> {
  CameraPermissionNotifier(
    this.read,
  ) : super(const CameraPermissionState()) {
    _initState();
  }

  static final _logger = Logger('CameraPermissionNotifier');

  final Reader read;

  Future<void> _initState() async {
    final storage = read(localStorageServicePod);
    final status = await storage.getString(cameraStatusKey);

    if (status == null) {
      _updateCameraStatus(CameraStatus.undefined);
    } else {
      _updateCameraStatus(CameraStatus.denied);
    }
  }

  Future<void> handleCameraPermission(BuildContext context) async {
    _logger.log(notifier, 'handleCameraPermission');

    if (state.cameraStatus == CameraStatus.denied) {
      _updateUserLocation(UserLocation.settings);
      await openAppSettings();
    } else {
      final status = await Permission.camera.request();
      await _setCameraStatusInStorage();

      if (status == PermissionStatus.granted) {
        if (!mounted) return;
        sAnalytics.kycCameraAllowed();
        UploadKycDocuments.pushReplacement(context);
      } else {
        sAnalytics.kycCameraNotAllowed();
        _updateCameraStatus(CameraStatus.denied);
      }
    }
  }

  Future<void> handleCameraPermissionAfterSettingsChange(
    BuildContext context,
    void Function() then,
  ) async {
    _logger.log(notifier, 'handleCameraPermissionAfterSettingsChange');

    final status = await Permission.camera.status;

    if (status == PermissionStatus.granted) {
      if (!mounted) return;
      then();
    }

    _updateUserLocation(UserLocation.app);
  }

  Future<void> _setCameraStatusInStorage() async {
    await read(localStorageServicePod).setString(cameraStatusKey, 'triggered');
  }

  void _updateCameraStatus(CameraStatus cameraStatus) {
    state = state.copyWith(cameraStatus: cameraStatus);
  }

  void _updateUserLocation(UserLocation location) {
    state = state.copyWith(userLocation: location);
  }
}
