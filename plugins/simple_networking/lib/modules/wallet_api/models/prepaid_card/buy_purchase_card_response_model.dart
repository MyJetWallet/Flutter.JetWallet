import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/purchase_card_brand_list_response_model.dart';

part 'buy_purchase_card_response_model.freezed.dart';
part 'buy_purchase_card_response_model.g.dart';

@freezed
class BuyPurchaseCardResponseModel with _$BuyPurchaseCardResponseModel {
  const factory BuyPurchaseCardResponseModel({
    required PurchaseCardBrandDtoModel brand,
    @DecimalSerialiser() required Decimal amount,
    @DecimalSerialiser() required Decimal commission,
  }) = _BuyPurchaseCardResponseModel;

  factory BuyPurchaseCardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BuyPurchaseCardResponseModelFromJson(json);
}
