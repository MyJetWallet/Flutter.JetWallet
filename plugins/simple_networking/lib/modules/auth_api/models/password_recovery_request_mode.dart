import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_recovery_request_mode.freezed.dart';
part 'password_recovery_request_mode.g.dart';

@freezed
class PasswordRecoveryRequestModel with _$PasswordRecoveryRequestModel {
  const factory PasswordRecoveryRequestModel({
    required String email,
    required String password,
    required String code,
  }) = _PasswordRecoveryRequestModel;

  factory PasswordRecoveryRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordRecoveryRequestModelFromJson(json);
}
