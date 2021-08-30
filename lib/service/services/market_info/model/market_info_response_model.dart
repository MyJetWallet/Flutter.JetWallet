import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_info_response_model.freezed.dart';
part 'market_info_response_model.g.dart';

@freezed
class MarketInfoResponseModel with _$MarketInfoResponseModel {
  const factory MarketInfoResponseModel({
    String? whitepaperUrl,
    required String officialWebsiteUrl,
    required double marketCap,
    required double supply,
    @JsonKey(name: 'volume24') required double dayVolume,
    required String aboutLess,
    required String aboutMore,
    required Fees fees,
  }) = _MarketInfoResponseModel;

  factory MarketInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MarketInfoResponseModelFromJson(json);
}

@freezed
class Fees with _$Fees {
  const factory Fees({
    required WithdrawalFee withdrawalFee,
  }) = _Fees;

  factory Fees.fromJson(Map<String, dynamic> json) =>
      _$FeesFromJson(json);
}

@freezed
class WithdrawalFee with _$WithdrawalFee {
  const factory WithdrawalFee({
    required String asset,
    required double size,
    required double feeType,
  }) = _WithdrawalFee;

  factory WithdrawalFee.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalFeeFromJson(json);
}
