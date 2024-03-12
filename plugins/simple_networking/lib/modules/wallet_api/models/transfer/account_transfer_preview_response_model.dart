import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'account_transfer_preview_response_model.freezed.dart';
part 'account_transfer_preview_response_model.g.dart';

@freezed
class AccountTransferPreviewResponseModel with _$AccountTransferPreviewResponseModel {
  const factory AccountTransferPreviewResponseModel({
    @DecimalSerialiser() required Decimal fromAmount,
    String? fromAsset,
    @DecimalSerialiser() required Decimal toAmount,
    String? toAsset,
    @DecimalNullSerialiser() Decimal? paymentFeeAmount,
    String? paymentFeeAsset,
    String? toIban,
    @Default(false) bool deviceBindingRequired,
    @DecimalNullSerialiser() Decimal? simpleFeeAmount,
    String? simpleFeeAsset,
    String? beneficiaryFullName,
    required String operationId,
    String? reference,
    @Default(false) bool smsVerificationRequired,
    String? receiverPhoneNumber,
  }) = _AccountTransferPreviewResponseModel;

  factory AccountTransferPreviewResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AccountTransferPreviewResponseModelFromJson(json);
}
