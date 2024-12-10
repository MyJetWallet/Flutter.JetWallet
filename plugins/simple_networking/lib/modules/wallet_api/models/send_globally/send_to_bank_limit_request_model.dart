import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_to_bank_limit_request_model.freezed.dart';

part 'send_to_bank_limit_request_model.g.dart';

@freezed
class SendToBankLimitRequestModel with _$SendToBankLimitRequestModel {
  factory SendToBankLimitRequestModel({
    final String? countryCode,
    final String? asset,
    final String? methodId,
  }) = _SendToBankLimitRequestModel;

  factory SendToBankLimitRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendToBankLimitRequestModelFromJson(json);
}
