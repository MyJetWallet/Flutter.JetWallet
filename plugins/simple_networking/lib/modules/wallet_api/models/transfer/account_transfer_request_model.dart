import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer/account_transfer_preview_request_model.dart';

part 'account_transfer_request_model.freezed.dart';
part 'account_transfer_request_model.g.dart';

@freezed
class AccountTransferRequestModel with _$AccountTransferRequestModel {
  const factory AccountTransferRequestModel({
    required String requestId,
    required String fromAssetSymbol,
    @DecimalSerialiser() required Decimal fromAmount,
    required CredentialsModel fromAccount,
    required CredentialsModel toAccount,
    required String operationId,
  }) = _AccountTransferRequestModel;

  factory AccountTransferRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AccountTransferRequestModelFromJson(json);
}
