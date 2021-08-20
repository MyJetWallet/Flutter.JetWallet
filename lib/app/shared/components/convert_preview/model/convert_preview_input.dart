import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/currency_model.dart';

part 'convert_preview_input.freezed.dart';

@freezed
class ConvertPreviewInput with _$ConvertPreviewInput {
  const factory ConvertPreviewInput({
    /// Needed for Buy and Sell feature, Must be non-null on Buy and Sell
    CurrencyModel? currency,
    @Default('Unknown') String assetDescription,
    required String fromAssetAmount,
    required String fromAssetSymbol,
    required String toAssetSymbol,
    required TriggerAction action,
  }) = _ConvertPreviewInput;
}

enum TriggerAction { convert, buy, sell }
