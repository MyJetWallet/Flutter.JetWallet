import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'gift_model.freezed.dart';
part 'gift_model.g.dart';

@freezed
abstract class GiftModel with _$GiftModel {
  const factory GiftModel({
    required dynamic id,
    @DecimalNullSerialiser() required Decimal? amount,
    required String? assetSymbol,
    required String? toPhoneNumber,
    required String? toEmail,
    required String? toName,
    required String? fromName,
    @Default(GiftStatus.fail) GiftStatus? status,
    required String? declineReason,
  }) = _GiftModel;

  factory GiftModel.fromJson(Map<String, dynamic> json) =>
      _$GiftModelFromJson(json);
}

enum GiftStatus {
  @JsonValue(0)
  waitingForUser,
  @JsonValue(1)
  pendingApproval,
  @JsonValue(2)
  inProgress,
  @JsonValue(3)
  success,
  @JsonValue(4)
  fail,
}
