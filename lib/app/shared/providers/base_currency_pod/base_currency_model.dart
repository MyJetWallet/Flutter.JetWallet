import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_currency_model.freezed.dart';

@freezed
class BaseCurrencyModel with _$BaseCurrencyModel {
  const factory BaseCurrencyModel({
    @Default('USD') String symbol,
    @Default(2) int accuracy,
  }) = _BaseCurrencyModel;
}
