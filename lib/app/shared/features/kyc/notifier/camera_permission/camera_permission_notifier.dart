import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/services/local_storage_service.dart';
import '../../../send_by_phone/view/screens/send_by_phone_input/components/show_contacts_permission_settings_alert.dart';
import '../../view/components/upload_documents/upload_kyc_documents.dart';
import '../choose_documents/choose_documents_state.dart';
import 'camera_permission_state.dart';

class CameraPermissionNotifier extends StateNotifier<CameraPermissionState> {
  CameraPermissionNotifier(
    this.read,
    this.activeDocument,
  ) : super(const CameraPermissionState()) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _initCameraStatus();
    initPermissionState();
  }

  static final _logger = Logger('SendByPhonePermissionNotifier');

  final Reader read;
  final DocumentsModel activeDocument;
  late BuildContext _context;

  Future<void> _initCameraStatus() async {
    final storage = read(localStorageServicePod);
    final status = await storage.getString(cameraStatusKey);

    print('VAlue from storage $status');

    if (status == CameraStatus.granted.name) {
      _updateCameraStatus(CameraStatus.granted);
    } else if (status == CameraStatus.denied.name) {
      _updateCameraStatus(CameraStatus.denied);
    } else if (status == CameraStatus.dismissed.name) {
      _updateCameraStatus(CameraStatus.dismissed);
    } else {
      _updateCameraStatus(CameraStatus.undefined);
    }
  }

  Future<void> initPermissionState() async {
    _logger.log(notifier, 'initPermissionState');

    final status = await Permission.camera.status;

    if (status == PermissionStatus.granted) {
      // await openAppSettings();
      _onPermissionGranted();
    } else {
      if (status != PermissionStatus.granted) {

      }
      await openAppSettings();
      _onPermissionDenied();
    }
  }

  void _showGoToSettings() {
    showContactsPermissionSettingsAlert(
      context: _context,
      onGoToSettings: () => openAppSettings().then((value) {
        Navigator.pop(_context);
        updateUserLocation(UserLocation.settings);
      }),
    );
  }

  void updateUserLocation(UserLocation location) {
    _logger.log(notifier, 'updateUserLocation');

    state = state.copyWith(userLocation: location);
  }

  void _onPermissionGranted() {
    _updatePermissionStatus(PermissionStatus.granted);
    UploadKycDocuments.pushReplacement(
      context: _context,
      activeDocument: activeDocument,
    );
  }

  void _onPermissionDenied() {
    _updatePermissionStatus(PermissionStatus.denied);
    _showUseCamera();
    // if (state.cameraStatus == CameraStatus.undefined ) {
    //
    // }
  }

  void _updatePermissionStatus(PermissionStatus status) {
    state = state.copyWith(permissionStatus: status);
  }

  void _updateCameraStatus(CameraStatus status) {
    state = state.copyWith(cameraStatus: status);
  }

  Future<void> _showUseCamera() async {
    const granted = CameraStatus.granted;
    const dismissed = CameraStatus.dismissed;
    const denied = CameraStatus.denied;

    print('_showUseCamera23');

    await openAppSettings();

    // showUsePhonebookAlert(
    //   context: _context,
    //   onUsePhonebook: () async {
    //     if (!mounted) return;
    //     Navigator.pop(_context); // close PhonebookAlert
    //
    //     final permission = await Permission.contacts.request();
    //
    //     if (permission == PermissionStatus.granted) {
    //       await _setCameraStatusInStorage(granted.name);
    //       _updateCameraStatus(granted);
    //       _updatePermissionStatus(permission);
    //       if (!mounted) return;
    //       showContactPicker(_context);
    //     } else {
    //       await _setCameraStatusInStorage(denied.name);
    //       _updateCameraStatus(denied);
    //       _updatePermissionStatus(permission);
    //     }
    //   },
    //   onPopupQuit: () async {
    //     await _setCameraStatusInStorage(dismissed.name);
    //     _updateCameraStatus(dismissed);
    //   },
    // );
  }

  Future<void> _setCameraStatusInStorage(String status) async {
    await read(localStorageServicePod).setString(cameraStatusKey, status);
  }
}
