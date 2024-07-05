import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_currency_model.freezed.dart';
part 'base_currency_model.g.dart';

@freezed
class BaseCurrencyModel with _$BaseCurrencyModel {
  const factory BaseCurrencyModel({
    String? prefix,
    @Default('USD') String symbol,
    @Default(2) int accuracy,
  }) = _BaseCurrencyModel;

  factory BaseCurrencyModel.fromJson(Map<String, dynamic> json) => _$BaseCurrencyModelFromJson(json);
}
