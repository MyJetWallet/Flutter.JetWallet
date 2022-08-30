import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_union.freezed.dart';

@freezed
class ChartUnion with _$ChartUnion {
  const factory ChartUnion.candles() = Candles;
  const factory ChartUnion.loading() = Loading;
  const factory ChartUnion.error(String error) = Error;
}
