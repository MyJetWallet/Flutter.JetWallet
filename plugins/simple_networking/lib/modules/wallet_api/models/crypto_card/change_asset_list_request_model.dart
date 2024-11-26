import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_asset_list_request_model.freezed.dart';
part 'change_asset_list_request_model.g.dart';

@freezed
class ChangeAssetListRequestModel with _$ChangeAssetListRequestModel {
  const factory ChangeAssetListRequestModel({
    required String cardId,
    required List<String> assets,
  }) = _ChangeAssetListRequestModel;

  factory ChangeAssetListRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeAssetListRequestModelFromJson(json);
}
