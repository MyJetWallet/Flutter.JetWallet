import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'send_to_bank_card_response.freezed.dart';
part 'send_to_bank_card_response.g.dart';

@freezed
class SendToBankCardResponse with _$SendToBankCardResponse {
  factory SendToBankCardResponse({
    final String? methodId,
    final String? countryCode,
    final String? asset,
    @DecimalSerialiser() Decimal? amount,
    @DecimalSerialiser() Decimal? feeAmount,
    final String? receiveAsset,
    @DecimalSerialiser() Decimal? estimatedReceiveAmount,
    @DecimalSerialiser() Decimal? estimatedPrice,
    final String? cardNumber,
    final String? iban,
    final String? phoneNumber,
    final String? recipientName,
    final String? panNumber,
    final String? upiAddress,
    final String? accountNumber,
    final String? beneficiaryName,
    final String? bankName,
    final String? ifscCode,
    final String? bankAccount,
    final String? wise,
  }) = _SendToBankCardResponse;

  factory SendToBankCardResponse.fromJson(Map<String, dynamic> json) =>
      _$SendToBankCardResponseFromJson(json);
}
