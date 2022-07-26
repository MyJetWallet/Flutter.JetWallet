import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../helpers/input_helpers.dart';
import '../../../../models/currency_model.dart';

part 'convert_input_state.freezed.dart';

@freezed
class ConvertInputState with _$ConvertInputState {
  const factory ConvertInputState({
    Decimal? converstionPrice,
    SKeyboardPreset? selectedPreset,
    String? tappedPreset,
    @Default('') String fromAssetAmount,
    @Default('') String toAssetAmount,
    @Default(true) bool fromAssetEnabled,
    @Default(false) bool toAssetEnabled,
    @Default(false) bool convertValid,
    @Default(InputError.none) InputError inputError,
    required CurrencyModel fromAsset,
    required CurrencyModel toAsset,
    required List<CurrencyModel> fromAssetList,
    required List<CurrencyModel> toAssetList,
  }) = _ConvertInputState;
}
