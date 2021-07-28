import 'package:freezed_annotation/freezed_annotation.dart';

import '../notifier/convert_input_notifier/convert_input_notifier.dart';

part 'conversion_price_input.freezed.dart';

@freezed
class ConversionPriceInput with _$ConversionPriceInput {
  const factory ConversionPriceInput({
    required String baseAssetSymbol,
    required String quotedAssetSymbol,
    required ConvertInputNotifier convertInputN,
  }) = _ConversionPriceInput;
}
