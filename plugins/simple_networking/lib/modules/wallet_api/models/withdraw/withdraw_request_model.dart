import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'withdraw_request_model.freezed.dart';
part 'withdraw_request_model.g.dart';

@freezed
class WithdrawRequestModel with _$WithdrawRequestModel {
  const factory WithdrawRequestModel({
    required String requestId,
    required String assetSymbol,
    @DecimalSerialiser() required Decimal amount,
    required String toAddress,
    String? toTag,
    required String blockchain,
    required String pin,
    String? lang,
  }) = _WithdrawRequestModel;

  factory WithdrawRequestModel.fromJson(Map<String, dynamic> json) => _$WithdrawRequestModelFromJson(json);
}

@freezed
class WithdrawJarRequestModel with _$WithdrawJarRequestModel {
  const factory WithdrawJarRequestModel({
    required String requestId,
    required String assetSymbol,
    @DecimalSerialiser() required Decimal amount,
    required String toAddress,
    String? toTag,
    required String blockchain,
    required String pin,
    String? lang,
    required String jarId,
  }) = _WithdrawJarRequestModel;

  factory WithdrawJarRequestModel.fromJson(Map<String, dynamic> json) => _$WithdrawJarRequestModelFromJson(json);
}
