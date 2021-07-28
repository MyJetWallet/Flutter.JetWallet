import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_converter_map_model.freezed.dart';
part 'asset_converter_map_model.g.dart';

@freezed
class AssetConverterMapModel with _$AssetConverterMapModel {
  const factory AssetConverterMapModel({
    required String baseAssetSymbol,
    required List<AssetConverterMapItemModel> maps,
  }) = _AssetConverterMapModel;

  factory AssetConverterMapModel.fromJson(Map<String, dynamic> json) =>
      _$AssetConverterMapModelFromJson(json);
}

@freezed
class AssetConverterMapItemModel with _$AssetConverterMapItemModel {
  const factory AssetConverterMapItemModel({
    required String assetSymbol,
    required List<AssetConverterMapOperationModel> operations,
  }) = _AssetConverterMapItemModel;

  factory AssetConverterMapItemModel.fromJson(Map<String, dynamic> json) =>
      _$AssetConverterMapItemModelFromJson(json);
}

@freezed
class AssetConverterMapOperationModel with _$AssetConverterMapOperationModel {
  const factory AssetConverterMapOperationModel({
    required int order,
    @JsonKey(name: 'instrumentPrice') required String instrumentPair,
    required bool isMultiply,
    required bool useBid,
  }) = _AssetConverterMapOperationModel;

  factory AssetConverterMapOperationModel.fromJson(Map<String, dynamic> json) =>
      _$AssetConverterMapOperationModelFromJson(json);
}
