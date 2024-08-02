import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'card_limits_model.freezed.dart';
part 'card_limits_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class CardLimitsModel with _$CardLimitsModel {
  const factory CardLimitsModel({
    @DecimalSerialiser() required Decimal minAmount,
    @DecimalSerialiser() required Decimal maxAmount,
    @DecimalSerialiser() required Decimal day1Amount,
    @DecimalSerialiser() required Decimal day1Limit,
    required StateLimitType day1State,
    @DecimalSerialiser() required Decimal day7Amount,
    @DecimalSerialiser() required Decimal day7Limit,
    required StateLimitType day7State,
    @DecimalSerialiser() required Decimal day30Amount,
    @DecimalSerialiser() required Decimal day30Limit,
    required StateLimitType day30State,
    required StateBarType barInterval,
    required int barProgress,
    required int leftHours,
  }) = _CardLimitsModel;

  factory CardLimitsModel.fromJson(Map<String, dynamic> json) => _$CardLimitsModelFromJson(json);
}

enum StateLimitType {
  @JsonValue(0)
  none,
  @JsonValue(1)
  active,
  @JsonValue(2)
  block,
}

enum StateBarType {
  @JsonValue(0)
  day1,
  @JsonValue(1)
  day7,
  @JsonValue(2)
  day30,
}
