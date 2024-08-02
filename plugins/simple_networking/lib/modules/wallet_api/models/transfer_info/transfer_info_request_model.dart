import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_info_request_model.freezed.dart';
part 'transfer_info_request_model.g.dart';

@freezed
class TransferInfoRequestModel with _$TransferInfoRequestModel {
  const factory TransferInfoRequestModel({
    @JsonKey(name: 'transferId') required String operationId,
  }) = _TransferInfoRequestModel;

  factory TransferInfoRequestModel.fromJson(Map<String, dynamic> json) => _$TransferInfoRequestModelFromJson(json);
}
