import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/decimal_serialiser.dart';

part 'market_info_model.freezed.dart';
part 'market_info_model.g.dart';


@freezed
class MarketInfoModel with _$MarketInfoModel {
  const factory MarketInfoModel({
    required List<TotalMarketInfoModel> marketInfo,

  }) = _MarketInfoModel;

  factory MarketInfoModel.fromList(List<dynamic> list) {
    return MarketInfoModel(
      marketInfo: list
          .map((e) => TotalMarketInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

@freezed
class TotalMarketInfoModel with _$TotalMarketInfoModel {
  const factory TotalMarketInfoModel({
    required  totalMarketInfo,


    @DecimalSerialiser() required Decimal volumeChange24H,
    @DecimalSerialiser() required Decimal marketCapChange24H,

    // required int weight,
    // required int referralInvited,
    // required int referralActivated,
    // @DecimalSerialiser() required Decimal bonusEarned,
    // @DecimalSerialiser() required Decimal commissionEarned,
    // @DecimalSerialiser() required Decimal total,
  }) = _TotalMarketInfoModel;

  factory TotalMarketInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TotalMarketInfoModelFromJson(json);
}
