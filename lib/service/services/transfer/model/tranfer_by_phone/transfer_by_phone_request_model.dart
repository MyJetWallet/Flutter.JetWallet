import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_by_phone_request_model.freezed.dart';

part 'transfer_by_phone_request_model.g.dart';

@freezed
class TransferByPhoneRequestModel with _$TransferByPhoneRequestModel {
  const factory TransferByPhoneRequestModel({
    required String requestId,
    required String assetSymbol,
    required double amount,
    required String toPhoneNumber,
    required String lang,
  }) = _TransferByPhoneRequestModel;

  factory TransferByPhoneRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TransferByPhoneRequestModelFromJson(json);
}
