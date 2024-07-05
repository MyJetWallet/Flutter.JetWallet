import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_base_assets_request_model.freezed.dart';
part 'set_base_assets_request_model.g.dart';

@freezed
class SetBaseAssetsRequestModel with _$SetBaseAssetsRequestModel {
  const factory SetBaseAssetsRequestModel({
    required String assetSymbol,
  }) = _SetBaseAssetsRequestModel;

  factory SetBaseAssetsRequestModel.fromJson(Map<String, dynamic> json) => _$SetBaseAssetsRequestModelFromJson(json);
}
