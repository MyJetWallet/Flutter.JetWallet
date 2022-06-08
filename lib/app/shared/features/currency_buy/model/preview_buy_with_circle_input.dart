import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';

import '../../../models/currency_model.dart';

part 'preview_buy_with_circle_input.freezed.dart';

@freezed
class PreviewBuyWithCircleInput with _$PreviewBuyWithCircleInput {
  const factory PreviewBuyWithCircleInput({
    required bool fromCard,
    required String amount,
    required CircleCard card,
    required CurrencyModel currency,
  }) = _PreviewBuyWithAssetInput;
}
