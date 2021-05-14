import 'package:json_annotation/json_annotation.dart';

import '../../model/wallet/asset_model.dart';

part 'assets_response_dto.g.dart';

@JsonSerializable()
class AssetsDto {
  AssetsDto({
    required this.assets,
    required this.now,
  });

  factory AssetsDto.fromJson(Map<String, dynamic> json) => _$AssetsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsDtoToJson(this);

  AssetsModel toModel() => AssetsModel(
        assets: assets
            .map((asset) => AssetModel(
                  symbol: asset.symbol,
                  description: asset.description,
                  accuracy: asset.accuracy,
                ))
            .toList(),
        now: now,
      );

  List<AssetDto> assets;
  int now;
}

@JsonSerializable()
class AssetDto {
  AssetDto({
    required this.symbol,
    required this.description,
    required this.accuracy,
  });

  factory AssetDto.fromJson(Map<String, dynamic> json) => _$AssetDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AssetDtoToJson(this);

  String symbol;
  String description;
  num accuracy;
}
