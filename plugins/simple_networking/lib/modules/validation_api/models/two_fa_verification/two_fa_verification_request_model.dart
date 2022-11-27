import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_verification_request_model.freezed.dart';
part 'two_fa_verification_request_model.g.dart';

@freezed
class TwoFaVerificationRequestModel with _$TwoFaVerificationRequestModel {
  const factory TwoFaVerificationRequestModel({
    required String language,
    required String deviceType,
  }) = _TwoFaVerificationRequestModel;

  factory TwoFaVerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TwoFaVerificationRequestModelFromJson(json);
}
