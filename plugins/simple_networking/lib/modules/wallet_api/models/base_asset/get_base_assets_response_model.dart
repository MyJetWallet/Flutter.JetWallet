import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_base_assets_response_model.freezed.dart';
part 'get_base_assets_response_model.g.dart';

@freezed
class GetBaseAssetsResponseModel with _$GetBaseAssetsResponseModel {
  const factory GetBaseAssetsResponseModel({
    required List<String> data,
  }) = _GetBaseAssetsResponseModel;

  factory GetBaseAssetsResponseModel.fromJson(Map<String, dynamic> json) => _$GetBaseAssetsResponseModelFromJson(json);
}
