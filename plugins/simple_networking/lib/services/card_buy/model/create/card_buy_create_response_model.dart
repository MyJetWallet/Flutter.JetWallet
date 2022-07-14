import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/decimal_serialiser.dart';

part 'card_buy_create_response_model.freezed.dart';
part 'card_buy_create_response_model.g.dart';

@freezed
class CardBuyCreateResponseModel with _$CardBuyCreateResponseModel {
  const factory CardBuyCreateResponseModel({
    String? paymentId,
    @DecimalSerialiser() required Decimal paymentAmount,
    String? paymentAsset,
    @DecimalSerialiser() required Decimal buyAmount,
    String? buyAsset,
    @DecimalSerialiser() required Decimal depositFeeAmount,
    String? depositFeeAsset,
    @DecimalSerialiser() required Decimal tradeFeeAmount,
    String? tradeFeeAsset,
    @DecimalSerialiser() required Decimal rate,
  }) = _CardBuyCreateResponseModel;

  factory CardBuyCreateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CardBuyCreateResponseModelFromJson(json);
}
