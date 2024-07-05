import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

part 'cards_model.freezed.dart';
part 'cards_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class CardsModel with _$CardsModel {
  const factory CardsModel({
    required double now,
    required List<CircleCard> cardInfos,
  }) = _CardsModel;

  factory CardsModel.fromJson(Map<String, dynamic> json) => _$CardsModelFromJson(json);
}

@freezed
class CardModel with _$CardModel {
  const factory CardModel({
    required String id,
    required String last4,
    String? network,
    required int expMonth,
    required int expYear,
    required CircleCardStatus status,
    required bool lastUsed,
    required CardPaymentDetailModel paymentDetails,
  }) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) => _$CardModelFromJson(json);
}

@freezed
class CardPaymentDetailModel with _$CardPaymentDetailModel {
  const factory CardPaymentDetailModel({
    @DecimalSerialiser() required Decimal minAmount,
    @DecimalSerialiser() required Decimal maxAmount,
    @DecimalSerialiser() required Decimal feePercentage,
    required String paymentAsset,
  }) = _CardPaymentDetailModel;

  factory CardPaymentDetailModel.fromJson(Map<String, dynamic> json) => _$CardPaymentDetailModelFromJson(json);
}

enum Network {
  @JsonValue('VISA')
  visa,
  @JsonValue('MASTERCARD')
  mastercard,
}
