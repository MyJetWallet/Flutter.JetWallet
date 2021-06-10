import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_request_model.freezed.dart';
part 'withdrawal_request_model.g.dart';

@freezed
class WithdrawalRequestModel with _$WithdrawalRequestModel {
  const factory WithdrawalRequestModel({
    required String requestId,
    required String assetSymbol,
    required int amount,
    required String toAddress,
  }) = _WithdrawalRequestModel;

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalRequestModelFromJson(json);
}
