import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_resend_request.freezed.dart';
part 'withdrawal_resend_request.g.dart';

@freezed
class WithdrawalResendRequestModel with _$WithdrawalResendRequestModel {
  const factory WithdrawalResendRequestModel({
    @JsonKey(name: 'id') required String operationId,
  }) = _WithdrawalResendRequestModel;

  factory WithdrawalResendRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalResendRequestModelFromJson(json);
}
