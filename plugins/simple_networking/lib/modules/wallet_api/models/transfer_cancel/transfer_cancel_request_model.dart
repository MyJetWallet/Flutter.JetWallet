import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_cancel_request_model.freezed.dart';
part 'transfer_cancel_request_model.g.dart';

@freezed
class TransferCancelRequestModel with _$TransferCancelRequestModel {
  const factory TransferCancelRequestModel({
    @JsonKey(name: 'transferId') required String? transferId,
  }) = _TransferCancelRequestModel;

  factory TransferCancelRequestModel.fromJson(Map<String, dynamic> json) => _$TransferCancelRequestModelFromJson(json);
}
