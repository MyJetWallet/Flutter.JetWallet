import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'invest_transfer_request_model.freezed.dart';
part 'invest_transfer_request_model.g.dart';

@freezed
class InvestTransferRequestModel with _$InvestTransferRequestModel {
  factory InvestTransferRequestModel({
    required String amountAssetId,
    @DecimalSerialiser() required Decimal amount,
  }) = _InvestTransferRequestModel;

  factory InvestTransferRequestModel.fromJson(Map<String, dynamic> json) => _$InvestTransferRequestModelFromJson(json);
}
