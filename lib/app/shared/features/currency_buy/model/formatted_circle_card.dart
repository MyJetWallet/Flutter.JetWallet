import 'package:freezed_annotation/freezed_annotation.dart';

part 'formatted_circle_card.freezed.dart';

@freezed
class FormattedCircleCard with _$FormattedCircleCard {
  const factory FormattedCircleCard({
    required String name,
    required String last4Digits,
    required String expDate,
    required String limit,
  }) = _FormattedCircleCard;
}
