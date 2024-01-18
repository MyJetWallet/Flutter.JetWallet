import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

part 'new_invest_request_model.freezed.dart';
part 'new_invest_request_model.g.dart';

@freezed
class NewInvestRequestModel with _$NewInvestRequestModel {
  factory NewInvestRequestModel({
    required String symbol,
    @DecimalNullSerialiser() required Decimal amount,
    required String amountAssetId,
    required int multiplicator,
    required Direction direction,
    required TPSLType takeProfitType,
    @DecimalNullSerialiser() required Decimal takeProfitValue,
    required TPSLType stopLossType,
    @DecimalNullSerialiser() required Decimal stopLossValue,
  }) = _NewInvestRequestModel;

  factory NewInvestRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NewInvestRequestModelFromJson(json);
}

@freezed
class NewInvestOrderRequestModel with _$NewInvestOrderRequestModel {
  factory NewInvestOrderRequestModel({
    required String symbol,
    @DecimalNullSerialiser() required Decimal amount,
    @DecimalNullSerialiser() required Decimal targetPrice,
    required String amountAssetId,
    required int multiplicator,
    required Direction direction,
    required TPSLType takeProfitType,
    @DecimalNullSerialiser() required Decimal takeProfitValue,
    required TPSLType stopLossType,
    @DecimalNullSerialiser() required Decimal stopLossValue,
  }) = _NewInvestOrderRequestModel;

  factory NewInvestOrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NewInvestOrderRequestModelFromJson(json);
}

enum TPSLType
{
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  price,
  @JsonValue(2)
  amount,
}

enum Direction
{
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  buy,
  @JsonValue(2)
  sell,
}

@freezed
class NewInvestJournalModel with _$NewInvestJournalModel {
  factory NewInvestJournalModel({
    required String positionId,
    required PositionAuditEvent auditEvent,
    required DateTime timestamp,
    required String officerId,
    required PositionStatus status,
    required DateTime creationTimestamp,
    @DecimalSerialiser() required Decimal pendingPrice,
    @DecimalSerialiser() required Decimal openPrice,
    @DecimalSerialiser() required Decimal openTriggerPrice,
    required String openTimestamp,
    @DecimalSerialiser() required Decimal closePrice,
    @DecimalSerialiser() required Decimal closeTriggerPrice,
    required DateTime closeTimestamp,
    required PositionCloseReason closeReason,
    required TPSLType takeProfitType,
    @DecimalSerialiser() required Decimal takeProfitAmount,
    @DecimalSerialiser() required Decimal takeProfitPrice,
    required TPSLType stopLossType,
    @DecimalSerialiser() required Decimal stopLossAmount,
    @DecimalSerialiser() required Decimal stopLossPrice,
    @DecimalSerialiser() required Decimal volume,
    @DecimalSerialiser() required Decimal volumeBase,
    @DecimalSerialiser() required Decimal openFee,
    @DecimalSerialiser() required Decimal closeFee,
    @DecimalSerialiser() required Decimal stopOutPrice,
    @DecimalSerialiser() required Decimal rollOver,
    @DecimalSerialiser() required Decimal profitLoss,
    @DecimalSerialiser() required Decimal marketProfitLoss,
    @DecimalSerialiser() required Decimal yield,
    @DecimalSerialiser() required Decimal amount,
    @DecimalSerialiser() required Decimal rollOverAmount,
    required String amountAssetId,
  }) = _NewInvestJournalModel;

  factory NewInvestJournalModel.fromJson(Map<String, dynamic> json) =>
      _$NewInvestJournalModelFromJson(json);
}

enum PositionCloseReason
{
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  stopLoss,
  @JsonValue(2)
  takeProfit,
  @JsonValue(3)
  marketClose,
  @JsonValue(4)
  liquidation,
}

enum PositionAuditEvent
{
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  createPending,
  @JsonValue(2)
  pendingToOpened,
  @JsonValue(3)
  pendingToCancel,
  @JsonValue(4)
  createMarketOpening,
  @JsonValue(5)
  marketOpeningToOpened,
  @JsonValue(6)
  openedToClosing,
  @JsonValue(7)
  closingToClose,
  @JsonValue(8)
  setTpSl,
  @JsonValue(9)
  closeByLiquidation,
  @JsonValue(10)
  closeByTakeProfit,
  @JsonValue(11)
  closeByStopLoss,
  @JsonValue(12)
  rollOverReCalc,
}

@freezed
class InvestSummaryModel with _$InvestSummaryModel {
  const factory InvestSummaryModel({
    String? symbol,
    @DecimalNullSerialiser() Decimal? qty,
    @DecimalNullSerialiser() Decimal? amount,
    @DecimalNullSerialiser() Decimal? amountPl,
    @DecimalNullSerialiser() Decimal? averageMultiplicator,
    @DecimalNullSerialiser() Decimal? percentPl,
  }) = _InvestSummaryModel;

  factory InvestSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$InvestSummaryModelFromJson(json);
}

