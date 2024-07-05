import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'market_info_model.freezed.dart';
part 'market_info_model.g.dart';

@freezed
class MarketInfoModel with _$MarketInfoModel {
  const factory MarketInfoModel({
    required TotalMarketInfoModel totalMarketInfo,
  }) = _MarketInfoModel;

  factory MarketInfoModel.fromJson(Map<String, dynamic> json) => _$MarketInfoModelFromJson(json);
}

@freezed
class TotalMarketInfoModel with _$TotalMarketInfoModel {
  const factory TotalMarketInfoModel({
    @DecimalSerialiser() required Decimal volumeChange24H,
    @DecimalSerialiser() required Decimal marketCapChange24H,
  }) = _TotalMarketInfoModel;

  factory TotalMarketInfoModel.fromJson(Map<String, dynamic> json) => _$TotalMarketInfoModelFromJson(json);
}
