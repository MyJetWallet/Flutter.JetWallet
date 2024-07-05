import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'conversion_price_model.freezed.dart';
part 'conversion_price_model.g.dart';

@freezed
class ConversionPriceModel with _$ConversionPriceModel {
  const factory ConversionPriceModel({
    String? error,
    required String baseAsset,
    required String quotedAsset,
    @DecimalSerialiser() required Decimal price,
    required String updateDate,
  }) = _ConversionPriceModel;

  factory ConversionPriceModel.fromJson(Map<String, dynamic> json) => _$ConversionPriceModelFromJson(json);
}
