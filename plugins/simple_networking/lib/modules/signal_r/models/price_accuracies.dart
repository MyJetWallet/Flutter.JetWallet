import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_accuracies.freezed.dart';
part 'price_accuracies.g.dart';

@freezed
class PriceAccuracies with _$PriceAccuracies {
  const factory PriceAccuracies({
    @JsonKey(name: 'settings') required List<PriceAccuracy> accuracies,
  }) = _PriceAccuracies;

  factory PriceAccuracies.fromJson(Map<String, dynamic> json) => _$PriceAccuraciesFromJson(json);
}

@freezed
class PriceAccuracy with _$PriceAccuracy {
  const factory PriceAccuracy({
    required String from,
    required String to,
    @JsonKey(name: 'priceAccuracy') required int accuracy,
  }) = _PriceAccuracy;

  factory PriceAccuracy.fromJson(Map<String, dynamic> json) => _$PriceAccuracyFromJson(json);
}
