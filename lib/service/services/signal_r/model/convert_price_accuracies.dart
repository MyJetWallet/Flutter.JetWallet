import 'package:freezed_annotation/freezed_annotation.dart';

part 'convert_price_accuracies.freezed.dart';
part 'convert_price_accuracies.g.dart';

@freezed
class ConvertPriceAccuracies with _$ConvertPriceAccuracies {
  const factory ConvertPriceAccuracies({
  @JsonKey(name: 'settings')  required List<ConvertPriceAccuracy> accuracies,
  }) = _ConvertPriceAccuracies;

  factory ConvertPriceAccuracies.fromJson(Map<String, dynamic> json) =>
      _$ConvertPriceAccuraciesFromJson(json);
}

@freezed
class ConvertPriceAccuracy with _$ConvertPriceAccuracy {
  const factory ConvertPriceAccuracy({
    required String from,
    required String to,
    @JsonKey(name: 'priceAccuracy') required int accuracy,
  }) = _ConvertPriceAccuracy;

  factory ConvertPriceAccuracy.fromJson(Map<String, dynamic> json) =>
      _$ConvertPriceAccuracyFromJson(json);
}
