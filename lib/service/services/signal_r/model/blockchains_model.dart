import 'package:freezed_annotation/freezed_annotation.dart';

import 'asset_model.dart';

part 'blockchains_model.freezed.dart';
part 'blockchains_model.g.dart';

@freezed
class BlockchainsModel with _$BlockchainsModel {
  const factory BlockchainsModel({
    required double now,
    required List<BlockchainModel> blockchains,
  }) = _BlockchainsModel;

  factory BlockchainsModel.fromJson(Map<String, dynamic> json) =>
      _$BlockchainsModelFromJson(json);
}

@freezed
class BlockchainModel with _$BlockchainModel {
  const factory BlockchainModel({
    required String id,
    required TagType tagType,
    required String description,
  }) = _BlockchainModel;

  factory BlockchainModel.fromJson(Map<String, dynamic> json) =>
      _$BlockchainModelFromJson(json);
}
