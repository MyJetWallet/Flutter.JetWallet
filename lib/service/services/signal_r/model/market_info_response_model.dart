import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/decimal_serialiser.dart';

part 'market_info_response_model.freezed.dart';
part 'market_info_response_model.g.dart';


@freezed
class MarketInfoResponseModel with _$MarketInfoResponseModel {
  const factory MarketInfoResponseModel({
    required List<MarketInfoModel> marketInfo,
  }) = _MarketInfoResponseModel;

  factory MarketInfoResponseModel.fromList(List<dynamic> list) {
    return MarketInfoResponseModel(
      marketInfo: list
          .map((e) => MarketInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

@freezed
class MarketInfoModel with _$MarketInfoModel {
  const factory MarketInfoModel({
    required TotalMarketInfoModel totalMarketInfo,
  }) = _MarketInfoModel;

  factory MarketInfoModel.fromJson(Map<String, dynamic> json) =>
      _$MarketInfoModelFromJson(json);
}

@freezed
class TotalMarketInfoModel with _$TotalMarketInfoModel {
  const factory TotalMarketInfoModel({
    @DecimalSerialiser() required Decimal volumeChange24H,
    @DecimalSerialiser() required Decimal marketCapChange24H,
  }) = _TotalMarketInfoModel;

  factory TotalMarketInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TotalMarketInfoModelFromJson(json);
}
