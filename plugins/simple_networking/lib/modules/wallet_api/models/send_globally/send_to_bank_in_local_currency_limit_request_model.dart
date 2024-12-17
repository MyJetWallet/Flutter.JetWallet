import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_to_bank_in_local_currency_limit_request_model.freezed.dart';

part 'send_to_bank_in_local_currency_limit_request_model.g.dart';

@freezed
class SendToBankInLocalCurrencyLimitRequestModel with _$SendToBankInLocalCurrencyLimitRequestModel {
  factory SendToBankInLocalCurrencyLimitRequestModel({
    final String? countryCode,
    final String? asset,
    final String? receiveAsset,
    final String? methodId,
  }) = _SendToBankInLocalCurrencyLimitRequestModel;

  factory SendToBankInLocalCurrencyLimitRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendToBankInLocalCurrencyLimitRequestModelFromJson(json);
}
