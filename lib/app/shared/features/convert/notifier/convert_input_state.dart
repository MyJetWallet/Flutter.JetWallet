import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../screens/market/model/currency_model.dart';

part 'convert_input_state.freezed.dart';

@freezed
class ConvertInputState with _$ConvertInputState {
  const factory ConvertInputState({
    double? converstionPrice,
    @Default('') String fromAssetAmount,
    @Default('') String toAssetAmount,
    @Default(true) bool fromAssetEnabled,
    @Default(false) bool toAssetEnabled,
    @Default(false) bool convertValid,
    required CurrencyModel fromAsset,
    required CurrencyModel toAsset,
    required List<CurrencyModel> fromAssetList,
    required List<CurrencyModel> toAssetList,
  }) = _ConvertInputState;
}
