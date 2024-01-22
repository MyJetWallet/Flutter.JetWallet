import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

import '../../wallet_api/models/invest/new_invest_request_model.dart';

part 'invest_positions_model.freezed.dart';
part 'invest_positions_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class InvestPositionsModel with _$InvestPositionsModel {
  const factory InvestPositionsModel({
    required List<InvestPositionModel> positions,
  }) = _InvestPositionsModel;

  factory InvestPositionsModel.fromJson(Map<String, dynamic> json) =>
      _$InvestPositionsModelFromJson(json);
}

@freezed
class InvestPositionModel with _$InvestPositionModel {
  const factory InvestPositionModel({
    String? id,
    String? symbol,
    @DecimalNullSerialiser() Decimal? amount,
    String? amountAssetId,
    int? multiplicator,
    Direction? direction,
    PositionType? positionType,
    PositionStatus? status,
    DateTime? creationTimestamp,
    @DecimalNullSerialiser() Decimal? pendingPrice,
    @DecimalNullSerialiser() Decimal? openPrice,
    @DecimalNullSerialiser() Decimal? openTriggerPrice,
    DateTime? openTimestamp,
    @DecimalNullSerialiser() Decimal? closePrice,
    @DecimalNullSerialiser() Decimal? closeTriggerPrice,
    DateTime? closeTimestamp,
    CloseReason? closeReason,
    TPSLType? takeProfitType,
    @DecimalNullSerialiser() Decimal? takeProfitAmount,
    @DecimalNullSerialiser() Decimal? takeProfitPrice,
    TPSLType? stopLossType,
    @DecimalNullSerialiser() Decimal? stopLossAmount,
    @DecimalNullSerialiser() Decimal? stopLossPrice,
    @DecimalNullSerialiser() Decimal? volume,
    @DecimalNullSerialiser() Decimal? volumeBase,
    @DecimalNullSerialiser() Decimal? openFee,
    @DecimalNullSerialiser() Decimal? closeFee,
    @DecimalNullSerialiser() Decimal? stopOutPrice,
    @DecimalNullSerialiser() Decimal? rollOver,
    @DecimalNullSerialiser() Decimal? profitLoss,
    @DecimalNullSerialiser() Decimal? marketProfitLoss,
    @DecimalNullSerialiser() Decimal? yield,
  }) = _InvestPositionModel;

  factory InvestPositionModel.fromJson(Map<String, dynamic> json) =>
      _$InvestPositionModelFromJson(json);
}

@freezed
class TPSLPositionModel with _$TPSLPositionModel {
  const factory TPSLPositionModel({
    required String positionId,
    TPSLType? takeProfitType,
    @DecimalNullSerialiser() Decimal? takeProfitValue,
    TPSLType? stopLossType,
    @DecimalNullSerialiser() Decimal? stopLossValue,
  }) = _TPSLPositionModel;

  factory TPSLPositionModel.fromJson(Map<String, dynamic> json) =>
      _$TPSLPositionModelFromJson(json);
}

@freezed
class InvestPositionResponseModel with _$InvestPositionResponseModel {
  const factory InvestPositionResponseModel({
    InvestPositionModel? position,
  }) = _InvestPositionResponseModel;

  factory InvestPositionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$InvestPositionResponseModelFromJson(json);
}

enum PositionType
{
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  market,
  @JsonValue(2)
  limit,
  @JsonValue(3)
  stop,
}

enum PositionStatus
{
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  draft,
  @JsonValue(2)
  pending,
  @JsonValue(3)
  opening,
  @JsonValue(4)
  opened,
  @JsonValue(5)
  closing,
  @JsonValue(6)
  closed,
  @JsonValue(7)
  cancelling,
  @JsonValue(8)
  cancelled,
  @JsonValue(9)
  draftCancelled,
}

enum CloseReason
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
