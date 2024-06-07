import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'simple_coin_history_model.freezed.dart';
part 'simple_coin_history_model.g.dart';

@freezed
class SimpleCoinHistoryModel with _$SimpleCoinHistoryModel {
  const factory SimpleCoinHistoryModel({
    required List<SimpleCoinHistoryItemModel> withdrawals,
  }) = _ActiveEarnPositionsMessage;

  factory SimpleCoinHistoryModel.fromJson(Map<String, dynamic> json) => _$SimpleCoinHistoryModelFromJson(json);
}

@freezed
class SimpleCoinHistoryItemModel with _$SimpleCoinHistoryItemModel {
  const factory SimpleCoinHistoryItemModel({
    required String id,
    @DecimalSerialiser() required Decimal amount,
    required String assetSymbol,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _SimpleCoinHistoryItemModel;

  factory SimpleCoinHistoryItemModel.fromJson(Map<String, dynamic> json) => _$SimpleCoinHistoryItemModelFromJson(json);
}
