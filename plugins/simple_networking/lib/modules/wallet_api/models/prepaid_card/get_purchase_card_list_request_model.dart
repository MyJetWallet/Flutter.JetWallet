import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_purchase_card_list_request_model.freezed.dart';
part 'get_purchase_card_list_request_model.g.dart';

@Freezed()
class GetPurchaseCardListRequestModel with _$GetPurchaseCardListRequestModel {
  @JsonSerializable(includeIfNull: false)
  const factory GetPurchaseCardListRequestModel({
    String? productId,
    @Default(0) int skip,
    @Default(20) int take,
    List<BuyPrepaidCardIntentionStatus>? statuses,
  }) = _GetPurchaseCardListRequestModel;

  factory GetPurchaseCardListRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GetPurchaseCardListRequestModelFromJson(json);
}

enum BuyPrepaidCardIntentionStatus {
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  created,
  @JsonValue(2)
  paid,
  @JsonValue(3)
  purchasing,
  @JsonValue(5)
  completed,
  @JsonValue(6)
  toRefund,
  @JsonValue(7)
  failed,
  @JsonValue(8)
  cantFindVaucher,
}
