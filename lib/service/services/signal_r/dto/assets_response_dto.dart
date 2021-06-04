import 'package:json_annotation/json_annotation.dart';

import '../model/asset_model.dart';

part 'assets_response_dto.g.dart';

@JsonSerializable()
class AssetsDto {
  AssetsDto({
    required this.assets,
    required this.now,
  });

  factory AssetsDto.fromJson(Map<String, dynamic> json) =>
      _$AssetsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsDtoToJson(this);

  AssetsModel toModel() => AssetsModel(
        assets: assets
            .map((asset) => AssetModel(
                  symbol: asset.symbol,
                  description: asset.description,
                  accuracy: asset.accuracy,
                  depositMode: asset.depositMode,
                  withdrawalMode: asset.withdrawalMode,
                  tagType: asset.tagType,
                ))
            .toList(),
        now: now,
      );

  final List<AssetDto> assets;
  final double now;
}

@JsonSerializable()
class AssetDto {
  AssetDto({
    required this.symbol,
    required this.description,
    required this.accuracy,
    required this.depositMode,
    required this.withdrawalMode,
    required this.tagType,
  });

  factory AssetDto.fromJson(Map<String, dynamic> json) =>
      _$AssetDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AssetDtoToJson(this);

  final String symbol;
  final String description;
  final double accuracy;
  final int depositMode;
  final int withdrawalMode;
  final int tagType;
}
