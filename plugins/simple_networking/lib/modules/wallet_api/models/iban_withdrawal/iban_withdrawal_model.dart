import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'iban_withdrawal_model.freezed.dart';
part 'iban_withdrawal_model.g.dart';

@freezed
class IbanWithdrawalModel with _$IbanWithdrawalModel {
  factory IbanWithdrawalModel({
    final String? requestId,
    final String? assetSymbol,
    @DecimalNullSerialiser() Decimal? amount,
    final String? lang,
    final String? contactId,
    final String? iban,
    final String? bic,
  }) = _IbanWithdrawalModel;

  factory IbanWithdrawalModel.fromJson(Map<String, dynamic> json) =>
      _$IbanWithdrawalModelFromJson(json);
}
