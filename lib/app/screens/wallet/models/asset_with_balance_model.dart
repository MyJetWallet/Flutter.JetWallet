import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_with_balance_model.freezed.dart';

@freezed
class AssetWithBalanceModel with _$AssetWithBalanceModel {
  const factory AssetWithBalanceModel({
    required String symbol,
    required String description,
    required double accuracy,
    required int depositMode,
    required int withdrawalMode,
    required int tagType,
    required String assetId,
    required double balance,
    required double reserve,
    required String lastUpdate,
    required double sequenceId,
  }) = _AssetWithBalanceModel;
}
