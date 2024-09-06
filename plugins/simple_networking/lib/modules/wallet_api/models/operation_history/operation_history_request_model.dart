import 'package:freezed_annotation/freezed_annotation.dart';

part 'operation_history_request_model.freezed.dart';
part 'operation_history_request_model.g.dart';

@freezed
class OperationHistoryRequestModel with _$OperationHistoryRequestModel {
  const factory OperationHistoryRequestModel({
    String? lastDate,
    int? batchSize,
    String? assetId,
    String? accountId,
    bool? pendingOnly,
    String? jarId,
  }) = _OperationHistoryRequestModel;

  factory OperationHistoryRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OperationHistoryRequestModelFromJson(json);
}
