import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'banking_withdrawal_request.freezed.dart';
part 'banking_withdrawal_request.g.dart';

@freezed
class BankingWithdrawalRequest with _$BankingWithdrawalRequest {
  factory BankingWithdrawalRequest({
    final String? pin,
    final String? accountId,
    final String? toIbanAddress,
    final String? assetSymbol,
    @DecimalNullSerialiser() final Decimal? amount,
    final String? description,
    final String? beneficiaryName,
    final String? beneficiaryAddress,
    final String? beneficiaryCountry,
    final String? beneficiaryBankCode,
    final String? intermediaryBankCode,
    final String? intermediaryBankAccount,
    final bool? expressPayment,
  }) = _BankingWithdrawalRequest;

  factory BankingWithdrawalRequest.fromJson(Map<String, dynamic> json) => _$BankingWithdrawalRequestFromJson(json);
}
