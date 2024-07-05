import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_info_response_model.freezed.dart';
part 'transfer_info_response_model.g.dart';

@freezed
class TransferInfoResponseModel with _$TransferInfoResponseModel {
  const factory TransferInfoResponseModel({
    required String id,
    required double amount,
    required String assetSymbol,
    required TransferStatus status,
    required String toPhoneNumber,
  }) = _TransferInfoResponseModel;

  factory TransferInfoResponseModel.fromJson(Map<String, dynamic> json) => _$TransferInfoResponseModelFromJson(json);
}

enum TransferStatus {
  @JsonValue(0)
  pendingApproval,
  @JsonValue(1)
  success,
  @JsonValue(2)
  fail,
}
