import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'camera_permission_state.freezed.dart';

enum CameraStatus { granted, dismissed, denied, undefined }
enum UserLocation { app, settings }

@freezed
class CameraPermissionState with _$CameraPermissionState {
  const factory CameraPermissionState({
    @Default(UserLocation.app) UserLocation userLocation,
    @Default(PermissionStatus.denied) PermissionStatus permissionStatus,
    @Default(CameraStatus.undefined) CameraStatus cameraStatus,
  }) = _CameraPermissionState;
}
