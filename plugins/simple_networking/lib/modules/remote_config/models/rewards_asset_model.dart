import 'package:freezed_annotation/freezed_annotation.dart';

part 'rewards_asset_model.freezed.dart';
part 'rewards_asset_model.g.dart';

@freezed
class RewardsAssetModel with _$RewardsAssetModel {
  factory RewardsAssetModel({
    required String name,
    required double value,
  }) = _RewardsAssetModel;

  factory RewardsAssetModel.fromJson(Map<String, dynamic> json) => _$RewardsAssetModelFromJson(json);
}
