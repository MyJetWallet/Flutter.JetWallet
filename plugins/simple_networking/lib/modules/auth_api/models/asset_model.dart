import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_model.freezed.dart';
part 'asset_model.g.dart';

@freezed
class AssetModelAdm with _$AssetModelAdm {
  const factory AssetModelAdm({
    required String id,
    required int accuracy,
    @JsonKey(name: 'profitLossAccuracy') required int profitLossAccuracy,
  }) = _AssetModelAdm;

  factory AssetModelAdm.fromJson(Map<String, dynamic> json) => _$AssetModelAdmFromJson(json);
}
