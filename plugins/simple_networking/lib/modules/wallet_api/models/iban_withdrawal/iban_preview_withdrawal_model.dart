import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

part 'iban_preview_withdrawal_model.freezed.dart';
part 'iban_preview_withdrawal_model.g.dart';

@freezed
class IbanPreviewWithdrawalModel with _$IbanPreviewWithdrawalModel {
  factory IbanPreviewWithdrawalModel({
    @DecimalNullSerialiser() Decimal? amount,
    @DecimalNullSerialiser() Decimal? sendAmount,
    @DecimalNullSerialiser() Decimal? feeAmount,
    final String? asset,
    final String? iban,
    final String? bic,
    final String? bankName,
    final AddressBookContactModel? contact,
    final String? description,
  }) = _IbanPreviewWithdrawalModel;

  factory IbanPreviewWithdrawalModel.fromJson(Map<String, dynamic> json) =>
      _$IbanPreviewWithdrawalModelFromJson(json);
}
