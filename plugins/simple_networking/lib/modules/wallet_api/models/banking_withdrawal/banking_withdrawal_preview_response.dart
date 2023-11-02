import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'banking_withdrawal_preview_response.freezed.dart';
part 'banking_withdrawal_preview_response.g.dart';

@freezed
class BankingWithdrawalPreviewResponse with _$BankingWithdrawalPreviewResponse {
  factory BankingWithdrawalPreviewResponse({
    final String? feeAsset,
    @DecimalNullSerialiser() final Decimal? amount,
    @DecimalNullSerialiser() final Decimal? feeAmount,
    @DecimalNullSerialiser() final Decimal? sendAmount,
    final String? asset,
    final String? iban,
    final bool? deviceBindingRequired,
    @DecimalNullSerialiser() final Decimal? simpleFeeAmount,
    final String? simpleFeeAsset,
  }) = _BankingWithdrawalPreviewResponse;

  factory BankingWithdrawalPreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$BankingWithdrawalPreviewResponseFromJson(json);
}
