import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'apple_pay_response_model.freezed.dart';
part 'apple_pay_response_model.g.dart';

@freezed
class ApplePayResponseModel with _$ApplePayResponseModel {
  factory ApplePayResponseModel(
      {String? description,
      @DecimalSerialiser() Decimal? paymentAmount,
      String? paymentAsset,
      @DecimalSerialiser() Decimal? paymentAmountTotal,
      String? buyAsset,
      @DecimalSerialiser() Decimal? buyAmount}) = _ApplePayResponseModel;

  factory ApplePayResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApplePayResponseModelFromJson(json);
}
