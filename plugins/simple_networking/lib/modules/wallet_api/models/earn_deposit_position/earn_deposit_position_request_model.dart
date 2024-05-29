import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'earn_deposit_position_request_model.freezed.dart';
part 'earn_deposit_position_request_model.g.dart';

@freezed
class EarnDepositPositionRequestModel with _$EarnDepositPositionRequestModel {
  const factory EarnDepositPositionRequestModel({
    required String requestId,
    required String positionId,
    required String assetId,
    @DecimalSerialiser() required Decimal amount,
  }) = _EarnDepositPositionRequestModel;

  factory EarnDepositPositionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EarnDepositPositionRequestModelFromJson(json);
}
