import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_verification_request_model.freezed.dart';
part 'email_verification_request_model.g.dart';

@freezed
class EmailVerificationRequestModel with _$EmailVerificationRequestModel {
  const factory EmailVerificationRequestModel({
    required String language,
    required String deviceType,
  }) = _EmailVerificationRequestModel;

  factory EmailVerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EmailVerificationRequestModelFromJson(json);
}
