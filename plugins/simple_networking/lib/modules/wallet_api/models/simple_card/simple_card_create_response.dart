import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'simple_card_create_response.freezed.dart';
part 'simple_card_create_response.g.dart';

@freezed
class SimpleCardCreateResponse with _$SimpleCardCreateResponse {
  factory SimpleCardCreateResponse({
    final bool? simpleKycRequired,
    final bool? bankingKycRequired,
    final SimpleCardModel? card,
  }) = _SimpleCardCreateResponse;

  factory SimpleCardCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$SimpleCardCreateResponseFromJson(json);
}

@freezed
class SimpleCardModel with _$SimpleCardModel {
  factory SimpleCardModel({
    final String? cardId,
    final String? cardPan,
    final String? cardExpDate,
    final String? cardType,
    final String? currency,
    final String? nameOnCard,
    final AccountStatusCard? status,
    @DecimalSerialiser() Decimal? balance,
  }) = _SimpleCardModel;

  factory SimpleCardModel.fromJson(Map<String, dynamic> json) =>
      _$SimpleCardModelFromJson(json);
}

enum AccountStatusCard {
  @JsonValue(0)
  inCreation,
  @JsonValue(1)
  active,
  @JsonValue(2)
  frozen,
  @JsonValue(3)
  inactive,
}
