import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_response_model.freezed.dart';

@freezed
class WithdrawalResponseModel with _$WithdrawalResponseModel {
  const factory WithdrawalResponseModel({
    required String operationId,
    required String txId,
    required String txUrl,
  }) = _WithdrawalResponseModel;
}
