import 'package:freezed_annotation/freezed_annotation.dart';

part 'return_rates_model.freezed.dart';

@freezed
class ReturnRatesModel with _$ReturnRatesModel {
  const factory ReturnRatesModel({
    required double dayPrice,
    required double weekPrice,
    required double monthPrice,
    required double threeMonthPrice,
  }) = _ReturnRatesModel;
}
