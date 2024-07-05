import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_verify_request_model.freezed.dart';
part 'two_fa_verify_request_model.g.dart';

@freezed
class TwoFaVerifyRequestModel with _$TwoFaVerifyRequestModel {
  const factory TwoFaVerifyRequestModel({
    required String code,
  }) = _TwoFaVerifyRequestModel;

  factory TwoFaVerifyRequestModel.fromJson(Map<String, dynamic> json) => _$TwoFaVerifyRequestModelFromJson(json);
}
