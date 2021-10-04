import 'package:freezed_annotation/freezed_annotation.dart';

part 'sms_verification_request_model.freezed.dart';
part 'sms_verification_request_model.g.dart';

@freezed
class SmsVerificationRequestModel with _$SmsVerificationRequestModel {
  const factory SmsVerificationRequestModel({
    required String language,
    required String deviceType,
  }) = _SmsVerificationRequestModel;

  factory SmsVerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SmsVerificationRequestModelFromJson(json);
}
