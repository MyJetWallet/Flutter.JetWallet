import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification_request_model.freezed.dart';
part 'phone_verification_request_model.g.dart';

@freezed
class PhoneVerificationRequestModel with _$PhoneVerificationRequestModel {
  const factory PhoneVerificationRequestModel({
    required String language,
    required String phoneNumber,
  }) = _PhoneVerificationRequestModel;

  factory PhoneVerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PhoneVerificationRequestModelFromJson(json);
}
