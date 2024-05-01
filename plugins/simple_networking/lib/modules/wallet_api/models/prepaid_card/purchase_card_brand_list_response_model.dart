import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'purchase_card_brand_list_response_model.freezed.dart';
part 'purchase_card_brand_list_response_model.g.dart';

@freezed
class PurchaseCardBrandDtoListResponseModel with _$PurchaseCardBrandDtoListResponseModel {
  const factory PurchaseCardBrandDtoListResponseModel({
    @JsonKey(name: 'data') @Default([]) List<PurchaseCardBrandDtoModel> brands,
  }) = _PurchaseCardBrandDtoListResponseModel;

  factory PurchaseCardBrandDtoListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseCardBrandDtoListResponseModelFromJson(json);
}

@freezed
class PurchaseCardBrandDtoModel with _$PurchaseCardBrandDtoModel {
  const factory PurchaseCardBrandDtoModel({
    required String brandName,
    required String countryName,
    required String currency,
    ValueRestrictionsModel? valueRestrictions,
    required int productId,
    required String productImage,
    @Default(false) bool isMobile,
    @DecimalSerialiser() required Decimal feePercentage,
    required String cardBrand,
  }) = _PurchaseCardBrandDtoModel;

  factory PurchaseCardBrandDtoModel.fromJson(Map<String, dynamic> json) => _$PurchaseCardBrandDtoModelFromJson(json);
}

@freezed
class ValueRestrictionsModel with _$ValueRestrictionsModel {
  const factory ValueRestrictionsModel({
    @DecimalSerialiser() required Decimal maxVal,
    @DecimalSerialiser() required Decimal minVal,
  }) = _ValueRestrictionsModel;

  factory ValueRestrictionsModel.fromJson(Map<String, dynamic> json) => _$ValueRestrictionsModelFromJson(json);
}
