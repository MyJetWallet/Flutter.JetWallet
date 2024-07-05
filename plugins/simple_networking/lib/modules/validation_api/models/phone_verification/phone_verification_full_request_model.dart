import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification_full_request_model.freezed.dart';
part 'phone_verification_full_request_model.g.dart';

@freezed
class PhoneVerificationFullRequestModel with _$PhoneVerificationFullRequestModel {
  const factory PhoneVerificationFullRequestModel({
    @JsonKey(name: 'language') required String locale,
    required int verificationType,
    required String requestId,
    String? pin,
  }) = _PhoneVerificationFullRequestModel;

  factory PhoneVerificationFullRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PhoneVerificationFullRequestModelFromJson(json);
}
