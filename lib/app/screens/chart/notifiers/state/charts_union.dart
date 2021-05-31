import 'package:freezed_annotation/freezed_annotation.dart';

part 'charts_union.freezed.dart';

@freezed
class ChartsUnion with _$ChartsUnion {
  const factory ChartsUnion.candles() = Candles;

  const factory ChartsUnion.loading() = Loading;

  const factory ChartsUnion.error(String error) = Error;
}
