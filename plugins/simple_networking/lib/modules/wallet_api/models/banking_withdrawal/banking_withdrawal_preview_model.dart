import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'banking_withdrawal_preview_model.freezed.dart';
part 'banking_withdrawal_preview_model.g.dart';

@freezed
class BankingWithdrawalPreviewModel with _$BankingWithdrawalPreviewModel {
  factory BankingWithdrawalPreviewModel({
    final String? accountId,
    final String? requestId,
    final String? toIbanAddress,
    final String? assetSymbol,
    final String? contactId,
    @DecimalNullSerialiser() final Decimal? amount,
    final String? description,
    final String? beneficiaryName,
    final String? beneficiaryAddress,
    final String? beneficiaryCountry,
    final String? beneficiaryBankCode,
    final String? intermediaryBankCode,
    final String? intermediaryBankAccount,
    final bool? expressPayment,
  }) = _BankingWithdrawalPreviewModel;

  factory BankingWithdrawalPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$BankingWithdrawalPreviewModelFromJson(json);
}
