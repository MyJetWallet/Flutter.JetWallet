import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/shared/features/kyc/notifier/camera_permission/camera_permission_state.dart';

part 'biometric_state.freezed.dart';

@freezed
class BiometricState with _$BiometricState {
  const factory BiometricState({
    @Default(UserLocation.app) UserLocation userLocation,
  }) = _BiometricState;

  const BiometricState._();
}
