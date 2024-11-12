import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
part 'allow_camera_store.g.dart';

enum CameraStatus { denied, undefined }

enum UserLocation { app, settings }

class AllowCameraStore extends _AllowCameraStoreBase with _$AllowCameraStore {
  AllowCameraStore() : super();

  static _AllowCameraStoreBase of(BuildContext context) => Provider.of<AllowCameraStore>(context, listen: false);
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

  @observable
  bool isAlreadyPushed = false;

  @observable
  bool isLoading = false;

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
    try {
      isLoading = true;

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
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> handleCameraPermissionAfterSettingsChange(
    BuildContext context,
    void Function() then,
  ) async {
    if (isAlreadyPushed) return;
    _logger.log(notifier, 'handleCameraPermissionAfterSettingsChange');

    final status = await Permission.camera.status;

    if (status == PermissionStatus.granted) {
      then();

      isAlreadyPushed = true;
    } else {
      final permissionStatus = await Permission.camera.request();
      if (permissionStatus == PermissionStatus.granted) {
        then();

        isAlreadyPushed = true;
      }
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
  void dispose() {
    isAlreadyPushed = false;
  }
}
