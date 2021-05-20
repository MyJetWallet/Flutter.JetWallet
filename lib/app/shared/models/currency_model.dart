import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_model.freezed.dart';

@freezed
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    required String name,
    required String symbol,
    required String image,
    required int amount,
    required String baseCurrencySymbol,
    required int baseCurrencyAmount,
  }) = _CurrencyModel;
}
