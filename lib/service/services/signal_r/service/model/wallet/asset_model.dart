import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_model.freezed.dart';

@freezed
class AssetsModel with _$AssetsModel {
  const factory AssetsModel({
    required List<AssetModel> assets,
    required int now,
  }) = _AssetsModel;
}

@freezed
class AssetModel with _$AssetModel {
  const factory AssetModel({
    required String symbol,
    required String description,
    required num accuracy,
  }) = _AssetModel;
}
