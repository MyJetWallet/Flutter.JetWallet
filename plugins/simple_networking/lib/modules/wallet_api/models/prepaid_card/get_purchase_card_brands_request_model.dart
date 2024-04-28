import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_purchase_card_brands_request_model.freezed.dart';
part 'get_purchase_card_brands_request_model.g.dart';

@freezed
class GetPurchaseCardBrandsRequestModel with _$GetPurchaseCardBrandsRequestModel {
  const factory GetPurchaseCardBrandsRequestModel({
    required String country,
  }) = _GetPurchaseCardBrandsRequestModel;

  factory GetPurchaseCardBrandsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GetPurchaseCardBrandsRequestModelFromJson(json);
}
