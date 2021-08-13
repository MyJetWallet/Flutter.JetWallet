import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversion_price_input.freezed.dart';

@freezed
class ConversionPriceInput with _$ConversionPriceInput {
  const factory ConversionPriceInput({
    required String targetAssetSymbol,
    required String quotedAssetSymbol,
    required Function(double) then,
  }) = _ConversionPriceInput;
}
