import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_transfer_response_model.freezed.dart';
part 'account_transfer_response_model.g.dart';

@freezed
class AccountTransferResponseModel with _$AccountTransferResponseModel {
  const factory AccountTransferResponseModel({
    required String operationId,
    @Default(false) bool smsVerificationRequired,
    String? receiverPhoneNumber,
  }) = _AccountTransferResponseModel;

  factory AccountTransferResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AccountTransferResponseModelFromJson(json);
}
