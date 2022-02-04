import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversion_price_input.freezed.dart';

@freezed
class ConversionPriceInput with _$ConversionPriceInput {
  const factory ConversionPriceInput({
    required String baseAssetSymbol,
    required String quotedAssetSymbol,
    required void Function(Decimal) then,
  }) = _ConversionPriceInput;
}
