import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'market_info_response_model.freezed.dart';
part 'market_info_response_model.g.dart';

@freezed
class MarketInfoResponseModel with _$MarketInfoResponseModel {
  const factory MarketInfoResponseModel({
    String? whitepaperUrl,
    String? officialWebsiteUrl,
    @DecimalSerialiser() required Decimal marketCap,
    @DecimalSerialiser() required Decimal supply,
    @DecimalSerialiser() @JsonKey(name: 'volume24') required Decimal dayVolume,
    required String aboutLess,
    required String aboutMore,
  }) = _MarketInfoResponseModel;

  factory MarketInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MarketInfoResponseModelFromJson(json);
}