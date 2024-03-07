import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

part 'earn_audit_history_model.freezed.dart';
part 'earn_audit_history_model.g.dart';

@freezed
class EarnPositionAuditClientModel with _$EarnPositionAuditClientModel {
  const factory EarnPositionAuditClientModel({
    required String id,
    required DateTime? timestamp,
    required DateTime? positionStartDateTime,
    required DateTime positionCloseDateTime,
    required String? assetId,
    required String? requestId,
    @JsonKey(unknownEnumValue: AuditEventType.undefined) required AuditEventType auditEventType,
    @JsonKey(unknownEnumValue: EarnOfferStatus.undefined) required EarnOfferStatus offerStatus,
    @JsonKey(unknownEnumValue: EarnPositionStatus.undefined) required EarnPositionStatus positionStatus,
    @DecimalSerialiser() required Decimal offerApyRate,
    @DecimalSerialiser() required Decimal positionBaseAmount,
    @DecimalSerialiser() required Decimal positionIncomeAmount,
    @DecimalSerialiser() required Decimal positionBaseAmountChange,
    @DecimalSerialiser() required Decimal positionIncomeAmountChange,
    @DecimalSerialiser() required Decimal indexPrice,
  }) = _EarnPositionAuditClientModel;

  factory EarnPositionAuditClientModel.fromJson(Map<String, dynamic> json) =>
      _$EarnPositionAuditClientModelFromJson(json);
}

enum AuditEventType {
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  positionCreate,
  @JsonValue(2)
  positionDeposit,
  @JsonValue(3)
  positionWithdraw,
  @JsonValue(4)
  positionCloseRequest,
  @JsonValue(5)
  positionClose,
  @JsonValue(6)
  positionIncomePayroll,
}
