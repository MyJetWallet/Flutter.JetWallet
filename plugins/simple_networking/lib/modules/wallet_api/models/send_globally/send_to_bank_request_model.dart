import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'send_to_bank_request_model.freezed.dart';
part 'send_to_bank_request_model.g.dart';

@freezed
class SendToBankRequestModel with _$SendToBankRequestModel {
  factory SendToBankRequestModel({
    final String? countryCode,
    final String? asset,
    @DecimalSerialiser() Decimal? amount,
    final String? methodId,
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
    final String? tin,
    final String? receiveAsset,
    required String pin,
  }) = _SendToBankRequestModel;

  factory SendToBankRequestModel.fromJson(Map<String, dynamic> json) => _$SendToBankRequestModelFromJson(json);
}
