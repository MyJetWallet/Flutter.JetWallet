import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'invest_instruments_model.freezed.dart';
part 'invest_instruments_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class InvestInstrumentsModel with _$InvestInstrumentsModel {
  const factory InvestInstrumentsModel({
    required List<InvestInstrumentModel> instruments,
  }) = _InvestInstrumentsModel;

  factory InvestInstrumentsModel.fromJson(Map<String, dynamic> json) =>
      _$InvestInstrumentsModelFromJson(json);
}

@freezed
class InvestInstrumentModel with _$InvestInstrumentModel {
  const factory InvestInstrumentModel({
    String? symbol,
    String? name,
    String? fullName,
    String? description,
    int? priceAccuracy,
    String? currencyBase,
    String? currencyQuote,
    List<String>? sectors,
    String? iconUrl,
    TradeMode? tradeMode,
    @DecimalNullSerialiser() Decimal? minVolume,
    @DecimalNullSerialiser() Decimal? maxVolume,
    int? minMultiply,
    int? maxMultiply,
    @DecimalNullSerialiser() Decimal? openFee,
    @DecimalNullSerialiser() Decimal? closeFee,
    @DecimalNullSerialiser() Decimal? stopOut,
    @DecimalNullSerialiser() Decimal? rollBuy,
    @DecimalNullSerialiser() Decimal? rollSell,
    @DecimalNullSerialiser() Decimal? pendingPriceRestrictions,
    @DecimalListSerialiser() List<Decimal>? takeProfitAmountLimits,
    @DecimalListSerialiser() List<Decimal>? takeProfitPriceLimits,
    @DecimalListSerialiser() List<Decimal>? stopLossAmountLimits,
    @DecimalListSerialiser() List<Decimal>? stopLossPriceLimits,
    int? volumeBaseAccuracy,
    DateTime? nextRollOverTime,
  }) = _InvestInstrumentModel;

  factory InvestInstrumentModel.fromJson(Map<String, dynamic> json) =>
      _$InvestInstrumentModelFromJson(json);
}

enum TradeMode
{
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  disabled,
  @JsonValue(2)
  longOnly,
  @JsonValue(3)
  shortOnly,
  @JsonValue(4)
  closeOnly,
  @JsonValue(5)
  full,
}
