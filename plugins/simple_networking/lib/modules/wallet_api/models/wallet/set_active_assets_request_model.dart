import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_active_assets_request_model.freezed.dart';
part 'set_active_assets_request_model.g.dart';

@freezed
class SetActiveAssetsRequestModel with _$SetActiveAssetsRequestModel {
  factory SetActiveAssetsRequestModel({
    @Default([]) List<ActiveAsset> activeAssets,
  }) = _SetActiveAssetsRequestModel;

  factory SetActiveAssetsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SetActiveAssetsRequestModelFromJson(json);
}

@freezed
class ActiveAsset with _$ActiveAsset {
  factory ActiveAsset({
    required String assetSymbol,
    required int order,
  }) = _ActiveAsset;

  factory ActiveAsset.fromJson(Map<String, dynamic> json) => _$ActiveAssetFromJson(json);
}
