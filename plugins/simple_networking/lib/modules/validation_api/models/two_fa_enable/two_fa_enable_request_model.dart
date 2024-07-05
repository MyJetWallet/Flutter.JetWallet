import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_enable_request_model.freezed.dart';
part 'two_fa_enable_request_model.g.dart';

@freezed
class TwoFaEnableRequestModel with _$TwoFaEnableRequestModel {
  const factory TwoFaEnableRequestModel({
    required String code,
  }) = _TwoFaEnableRequestModel;

  factory TwoFaEnableRequestModel.fromJson(Map<String, dynamic> json) => _$TwoFaEnableRequestModelFromJson(json);
}
