import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_request_model.freezed.dart';
part 'forgot_password_request_model.g.dart';

@freezed
class ForgotPasswordRequestModel with _$ForgotPasswordRequestModel {
  const factory ForgotPasswordRequestModel({
    required String email,
    required String deviceType,
  }) = _ForgotPasswordRequestModel;

  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) => _$ForgotPasswordRequestModelFromJson(json);
}
