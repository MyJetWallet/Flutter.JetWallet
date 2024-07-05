import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_resend_request_model.freezed.dart';
part 'transfer_resend_request_model.g.dart';

@freezed
class TransferResendRequestModel with _$TransferResendRequestModel {
  const factory TransferResendRequestModel({
    @JsonKey(name: 'id') required String operationId,
  }) = _TransferResendRequestModel;

  factory TransferResendRequestModel.fromJson(Map<String, dynamic> json) => _$TransferResendRequestModelFromJson(json);
}
