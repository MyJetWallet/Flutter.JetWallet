import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
part 'allow_camera_store.g.dart';

enum CameraStatus { denied, undefined }

enum UserLocation { app, settings }

class AllowCameraStore extends _AllowCameraStoreBase with _$AllowCameraStore {
  AllowCameraStore() : super();

  static _AllowCameraStoreBase of(BuildContext context) =>
      Provider.of<AllowCameraStore>(context, listen: false);
}

abstract class _AllowCameraStoreBase with Store {
  _AllowCameraStoreBase() {
    _initState();
  }

  static final _logger = Logger('CameraPermissionNotifier');

  @observable
  UserLocation userLocation = UserLocation.app;

  @observable
  CameraStatus cameraStatus = CameraStatus.undefined;

  @computed
  bool get permissionDenied {
    return cameraStatus == CameraStatus.denied;
  }

  @action
  Future<void> _initState() async {
    final storage = getIt.get<LocalStorageService>();
    final status = await storage.getValue(cameraStatusKey);

    if (status == null) {
      updateCameraStatus(CameraStatus.undefined);
    } else {
      updateCameraStatus(CameraStatus.denied);
    }
  }

  @action
  Future<void> handleCameraPermission(BuildContext context) async {
    _logger.log(notifier, 'handleCameraPermission');

    if (cameraStatus == CameraStatus.denied) {
      updateUserLocation(UserLocation.settings);
      await openAppSettings();
    } else {
      final status = await Permission.camera.request();
      await _setCameraStatusInStorage();

      if (status == PermissionStatus.granted) {
        // TODO
        //UploadKycDocuments.pushReplacement(context);
      } else {
        updateCameraStatus(CameraStatus.denied);
      }
    }
  }

  @action
  Future<void> handleCameraPermissionAfterSettingsChange(
    BuildContext context,
    void Function() then,
  ) async {
    _logger.log(notifier, 'handleCameraPermissionAfterSettingsChange');

    final status = await Permission.camera.status;

    if (status == PermissionStatus.granted) {
      then();
    }

    updateUserLocation(UserLocation.app);
  }

  @action
  Future<void> _setCameraStatusInStorage() async {
    await getIt.get<LocalStorageService>().setString(
          cameraStatusKey,
          'triggered',
        );
  }

  @action
  void updateCameraStatus(CameraStatus camStatus) {
    cameraStatus = camStatus;
  }

  @action
  void updateUserLocation(UserLocation location) {
    userLocation = location;
  }

  @action
  void dispose() {}
}
