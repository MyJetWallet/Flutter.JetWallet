import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_verification_response_model.freezed.dart';
part 'email_verification_response_model.g.dart';

@freezed
class EmailVerificationResponseModel with _$EmailVerificationResponseModel {
  const factory EmailVerificationResponseModel({
    required String data,
  }) = _EmailVerificationRequestModel;

  factory EmailVerificationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$EmailVerificationResponseModelFromJson(json);
}
