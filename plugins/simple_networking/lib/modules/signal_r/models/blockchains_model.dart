import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/modules/wallet_api/models/fee_info/fee_preview_response_model.dart';

import 'asset_model.dart';

part 'blockchains_model.freezed.dart';
part 'blockchains_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class BlockchainsModel with _$BlockchainsModel {
  const factory BlockchainsModel({
    required List<BlockchainModel> blockchains,
  }) = _BlockchainsModel;

  factory BlockchainsModel.fromJson(Map<String, dynamic> json) => _$BlockchainsModelFromJson(json);
}

@freezed
class BlockchainModel with _$BlockchainModel {
  const factory BlockchainModel({
    @Default('') String id,
    @Default(TagType.none) TagType tagType,
    @Default('') String description,
    @Default('') String blockchainExplorerUrlTemplate,
    /// Additional information, take from the endpoint /fee-info
    NetworkPreviewModel? info,
  }) = _BlockchainModel;

  factory BlockchainModel.fromJson(Map<String, dynamic> json) => _$BlockchainModelFromJson(json);
}
