import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/decimal_serialiser.dart';

part 'withdraw_request_model.freezed.dart';
part 'withdraw_request_model.g.dart';

@freezed
class WithdrawRequestModel with _$WithdrawRequestModel {
  const factory WithdrawRequestModel({
    required String requestId,
    required String assetSymbol,
    @DecimalSerialiser() required Decimal amount,
    required String toAddress,
  }) = _WithdrawRequestModel;

  factory WithdrawRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawRequestModelFromJson(json);
}
