import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_recovery_request_model.freezed.dart';
part 'password_recovery_request_model.g.dart';

@freezed
class PasswordRecoveryRequestModel with _$PasswordRecoveryRequestModel {
  const factory PasswordRecoveryRequestModel({
    required String password,
    required String token,
  }) = _PasswordRecoveryRequestModel;

  factory PasswordRecoveryRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordRecoveryRequestModelFromJson(json);
}
