import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'buy_purchase_card_request_model.freezed.dart';
part 'buy_purchase_card_request_model.g.dart';

@freezed
class BuyPurchaseCardRequestModel with _$BuyPurchaseCardRequestModel {
  const factory BuyPurchaseCardRequestModel({
    required int productId,
    @DecimalSerialiser() required Decimal amount,
    required String country,
  }) = _BuyPurchaseCardRequestModel;

  factory BuyPurchaseCardRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BuyPurchaseCardRequestModelFromJson(json);
}
