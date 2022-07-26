import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/decimal_serialiser.dart';

part 'card_buy_create_request_model.freezed.dart';
part 'card_buy_create_request_model.g.dart';

@freezed
class CardBuyCreateRequestModel with _$CardBuyCreateRequestModel {
  const factory CardBuyCreateRequestModel({
    @DecimalSerialiser() required Decimal paymentAmount,
    String? paymentAsset,
    String? buyAsset,
    required CirclePaymentMethod paymentMethod,
    CirclePaymentDataModel? circlePaymentData,
  }) = _CardBuyCreateRequestModel;

  factory CardBuyCreateRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CardBuyCreateRequestModelFromJson(json);
}

@freezed
class CirclePaymentDataModel with _$CirclePaymentDataModel {
  const factory CirclePaymentDataModel({
    required String cardId,
  }) = _CirclePaymentDataModel;

  factory CirclePaymentDataModel.fromJson(Map<String, dynamic> json) =>
      _$CirclePaymentDataModelFromJson(json);
}


enum CirclePaymentMethod {
  @JsonValue(0)
  circle,
}
