import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_currency_model.freezed.dart';

@freezed
class BaseCurrencyModel with _$BaseCurrencyModel {
  const factory BaseCurrencyModel({
    required String symbol,
    required double accuracy,
  }) = _BaseCurrencyModel;
}
