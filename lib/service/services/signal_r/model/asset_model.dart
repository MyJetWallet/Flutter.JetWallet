import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_model.freezed.dart';
part 'asset_model.g.dart';

@freezed
class AssetsModel with _$AssetsModel {
  const factory AssetsModel({
    required double now,
    required List<AssetModel> assets,
  }) = _AssetsModel;

  factory AssetsModel.fromJson(Map<String, dynamic> json) =>
      _$AssetsModelFromJson(json);
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

  factory AssetModel.fromJson(Map<String, dynamic> json) =>
      _$AssetModelFromJson(json);
}
