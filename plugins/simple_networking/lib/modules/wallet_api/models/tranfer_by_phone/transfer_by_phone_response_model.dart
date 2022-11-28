import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_by_phone_response_model.freezed.dart';
part 'transfer_by_phone_response_model.g.dart';

@freezed
class TransferByPhoneResponseModel with _$TransferByPhoneResponseModel {
  const factory TransferByPhoneResponseModel({
    required String operationId,
    required bool receiverIsRegistered,
  }) = _TransferByPhoneResponseModel;

  factory TransferByPhoneResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TransferByPhoneResponseModelFromJson(json);
}
