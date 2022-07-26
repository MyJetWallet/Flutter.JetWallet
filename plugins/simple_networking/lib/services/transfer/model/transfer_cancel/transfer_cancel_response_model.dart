import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_cancel_response_model.freezed.dart';
part 'transfer_cancel_response_model.g.dart';

@freezed
class TransferCancelResponseModel with _$TransferCancelResponseModel{
  const factory TransferCancelResponseModel({
    required String? transferId,
    required String? errorMessage,
    required bool isSuccess,
  }) = _TransferCancelResponseModel;

  factory TransferCancelResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TransferCancelResponseModelFromJson(json);
}
