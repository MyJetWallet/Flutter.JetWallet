import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'withdraw_response_model.freezed.dart';

part 'withdraw_response_model.g.dart';

@freezed
class WithdrawResponseModel with _$WithdrawResponseModel {
  const factory WithdrawResponseModel({
    required String operationId,
  }) = _WithdrawResponseModel;

  factory WithdrawResponseModel.fromJson(Map<String, dynamic> json) => _$WithdrawResponseModelFromJson(json);
}

@freezed
class WithdrawJarLimitResponseModel with _$WithdrawJarLimitResponseModel {
  const factory WithdrawJarLimitResponseModel({
    @DecimalSerialiser() required Decimal totalAmount,
    @DecimalSerialiser() required Decimal limit,
    @DecimalSerialiser() required Decimal leftAmount,
  }) = _WithdrawJarLimitResponseModel;

  factory WithdrawJarLimitResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawJarLimitResponseModelFromJson(json);
}
