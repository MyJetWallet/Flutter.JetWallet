import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_permission_state.freezed.dart';

enum CameraStatus { denied, undefined }
enum UserLocation { app, settings }

@freezed
class CameraPermissionState with _$CameraPermissionState {
  const factory CameraPermissionState({
    @Default(UserLocation.app) UserLocation userLocation,
    @Default(CameraStatus.undefined) CameraStatus cameraStatus,
  }) = _CameraPermissionState;

  const CameraPermissionState._();

  bool get permissionDenied {
    return cameraStatus == CameraStatus.denied;
  }

}
