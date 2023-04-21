import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'send_to_bank_card_response.freezed.dart';
part 'send_to_bank_card_response.g.dart';

@freezed
class SendToBankCardResponse with _$SendToBankCardResponse {
  factory SendToBankCardResponse({
    final String? countryCode,
    final String? cardNumber,
    final String? asset,
    @DecimalSerialiser() Decimal? amount,
    @DecimalSerialiser() Decimal? feeAmount,
    final String? receiveAsset,
    @DecimalSerialiser() Decimal? estimatedReceiveAmount,
    @DecimalSerialiser() Decimal? estimatedPrice,
  }) = _SendToBankCardResponse;

  factory SendToBankCardResponse.fromJson(Map<String, dynamic> json) =>
      _$SendToBankCardResponseFromJson(json);
}
