import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'earn_withdraw_position_request_model.freezed.dart';
part 'earn_withdraw_position_request_model.g.dart';

@freezed
class EarnWithdrawPositionRequestModel with _$EarnWithdrawPositionRequestModel {
  const factory EarnWithdrawPositionRequestModel({
    required String requestId,
    required String positionId,
    @DecimalSerialiser() required Decimal amount,
  }) = _EarnWithdrawPositionRequestModel;

  factory EarnWithdrawPositionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EarnWithdrawPositionRequestModelFromJson(json);
}
