import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_model.freezed.dart';

@freezed
class AssetsModel with _$AssetsModel {
  const factory AssetsModel({
    required List<AssetModel> assets,
    required double now,
  }) = _AssetsModel;
}

@freezed
class AssetModel with _$AssetModel {
  const factory AssetModel({
    required String symbol,
    required String description,
    required double accuracy,
    required int depositMode,
    required int withdrawalMode,
    required int tagType,
  }) = _AssetModel;
}
