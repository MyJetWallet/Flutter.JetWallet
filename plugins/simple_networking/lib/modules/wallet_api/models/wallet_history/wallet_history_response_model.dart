import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_history_response_model.freezed.dart';
part 'wallet_history_response_model.g.dart';

@freezed
class WalletHistoryResponseModel with _$WalletHistoryResponseModel {
  const factory WalletHistoryResponseModel({
    // TODO replace by Decimal
    required Map<String, double> graph,
  }) = _WalletHistoryResponseModel;

  factory WalletHistoryResponseModel.fromJson(Map<String, dynamic> json) => _$WalletHistoryResponseModelFromJson(json);
}
