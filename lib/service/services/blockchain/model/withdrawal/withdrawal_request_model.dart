import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_request_model.freezed.dart';

@freezed
class WithdrawalRequestModel with _$WithdrawalRequestModel {
  const factory WithdrawalRequestModel({
    required String requestId,
    required String walletId,
    required String assetSymbol,
    required int amount,
    required String toAddress,
  }) = _WithdrawalRequestModel;
}
