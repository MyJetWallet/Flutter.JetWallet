import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_history_request_model.freezed.dart';
part 'wallet_history_request_model.g.dart';

@freezed
class WalletHistoryRequestModel with _$WalletHistoryRequestModel {
  const factory WalletHistoryRequestModel({
    required String targetAsset,
    required TimeLength period,
  }) = _WalletHistoryRequestModel;

  factory WalletHistoryRequestModel.fromJson(Map<String, dynamic> json) => _$WalletHistoryRequestModelFromJson(json);
}

enum TimeLength {
  @JsonValue(0)
  day,
  @JsonValue(1)
  week,
  @JsonValue(2)
  month,
  @JsonValue(3)
  threeMonth,
  @JsonValue(4)
  year,
  @JsonValue(5)
  all,
}
