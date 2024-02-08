import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

part 'active_earn_positions_model.freezed.dart';
part 'active_earn_positions_model.g.dart';

@freezed
class ActiveEarnPositionsMessage with _$ActiveEarnPositionsMessage {
  const factory ActiveEarnPositionsMessage({
    required List<EarnOfferClientModel> positions,
  }) = _ActiveEarnPositionsMessage;

  factory ActiveEarnPositionsMessage.fromJson(Map<String, dynamic> json) => _$ActiveEarnPositionsMessageFromJson(json);
}

@freezed
class EarnPositionClientModel with _$EarnPositionClientModel {
  const factory EarnPositionClientModel({
    required String id,
    required String offerId,
    required String assetId,
    @DecimalSerialiser() required Decimal baseAmount,
    @DecimalSerialiser() required Decimal incomeAmount,
    @Default(EarnPositionStatus.undefined)
    @JsonKey(unknownEnumValue: EarnPositionStatus.undefined)
    EarnPositionStatus status,
    @Default(WithdrawType.undefined) @JsonKey(unknownEnumValue: WithdrawType.undefined) WithdrawType withdrawType,
    DateTime? startDateTime,
    DateTime? closeRequestDateTime,
    DateTime? closeDateTime,
    DateTime? paymentDateTime,
  }) = _EarnPositionClientModel;

  factory EarnPositionClientModel.fromJson(Map<String, dynamic> json) => _$EarnPositionClientModelFromJson(json);
}

enum EarnPositionStatus {
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  active,
  @JsonValue(2)
  closing,
  @JsonValue(3)
  closed,
}
