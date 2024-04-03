import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_purchase_card_list_request_model.dart';

part 'buy_prepaid_card_intention_dto_list_response_model.freezed.dart';
part 'buy_prepaid_card_intention_dto_list_response_model.g.dart';

@freezed
class BuyPrepaidCardIntentionDtoListResponseModel with _$BuyPrepaidCardIntentionDtoListResponseModel {
  const factory BuyPrepaidCardIntentionDtoListResponseModel({
    @JsonKey(name: 'data') @Default([]) List<PrapaidCardVoucherModel> vouchers,
  }) = _BuyPrepaidCardIntentionDtoListResponseModel;

  factory BuyPrepaidCardIntentionDtoListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BuyPrepaidCardIntentionDtoListResponseModelFromJson(json);
}

@freezed
class PrapaidCardVoucherModel with _$PrapaidCardVoucherModel {
  const factory PrapaidCardVoucherModel({
    required DateTime createdAt,
    required DateTime lastUpdate,
    @JsonKey(unknownEnumValue: BuyPrepaidCardIntentionStatus.undefined) required BuyPrepaidCardIntentionStatus status,
    @JsonKey(unknownEnumValue: BuyPrepaidCardIntentionRejectCodes.none)
    required BuyPrepaidCardIntentionRejectCodes rejectCode,
    required String paymentAsset,
    @DecimalSerialiser() required Decimal paymentAmount,
    required String cardAsset,
    @DecimalSerialiser() required Decimal cardAmount,
    required String productId,
    required String orderId,
    @DecimalSerialiser() required Decimal partnerRevenueSharePercent,
    String? merchantAsset,
    @DecimalNullSerialiser() Decimal? merchantCost,
    @DecimalNullSerialiser() Decimal? merchantCommission,
    @DecimalNullSerialiser() Decimal? phazeCommission,
    @DecimalNullSerialiser() Decimal? merchantAssetIndexPrice,
    required String productName,
    required String productCountry,
    required String feeAsset,
    @DecimalSerialiser() required Decimal feeAmount,
    String? productImage,
    String? voucherUrl,
    String? voucherCode,
    String? lastError,
    @Default(false) bool isMobile,
  }) = _PrapaidCardVoucherModel;

  factory PrapaidCardVoucherModel.fromJson(Map<String, dynamic> json) => _$PrapaidCardVoucherModelFromJson(json);
}

enum BuyPrepaidCardIntentionRejectCodes {
  @JsonValue(0)
  none,
  @JsonValue(1)
  ok,
  @JsonValue(2)
  lowBalance,
  @JsonValue(3)
  cannotExecutePurchase,
  @JsonValue(4)
  notEnoughLiquidity,
  @JsonValue(5)
  badRequest,
}
