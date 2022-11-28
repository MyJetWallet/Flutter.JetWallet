import 'package:freezed_annotation/freezed_annotation.dart';

part 'return_rates_model.freezed.dart';

@freezed
class ReturnRatesModel with _$ReturnRatesModel {
  const factory ReturnRatesModel({
    @Default(0.0) double dayPrice,
    @Default(0.0) double weekPrice,
    @Default(0.0) double monthPrice,
    @Default(0.0) double threeMonthPrice,
  }) = _ReturnRatesModel;
}
