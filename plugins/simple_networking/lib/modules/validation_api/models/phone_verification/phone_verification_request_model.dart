import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification_request_model.freezed.dart';
part 'phone_verification_request_model.g.dart';

@freezed
class PhoneVerificationRequestModel with _$PhoneVerificationRequestModel {
  const factory PhoneVerificationRequestModel({
    @JsonKey(name: 'language') required String locale,
    required String phoneBody,
    required String phoneCode,
    required String phoneIso,
    required int verificationType,
    required String requestId,
    String? pin,
  }) = _PhoneVerificationRequestModel;

  factory PhoneVerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PhoneVerificationRequestModelFromJson(json);
}
