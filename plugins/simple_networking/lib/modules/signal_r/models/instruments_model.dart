import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'instruments_model.freezed.dart';
part 'instruments_model.g.dart';

@freezed
class InstrumentsModel with _$InstrumentsModel {
  const factory InstrumentsModel({
    required double now,
    @JsonKey(name: 'spotInstruments')
    required List<InstrumentModel> instruments,
  }) = _InstrumentsModel;

  factory InstrumentsModel.fromJson(Map<String, dynamic> json) =>
      _$InstrumentsModelFromJson(json);
}

@freezed
class InstrumentModel with _$InstrumentModel {
  const factory InstrumentModel({
    required String symbol,
    required String baseAsset,
    required String quoteAsset,
    required int accuracy,
    @DecimalSerialiser() required Decimal minVolume,
    @DecimalSerialiser() required Decimal maxVolume,
    @DecimalSerialiser() required Decimal maxOppositeVolume,
  }) = _InstrumentModel;

  factory InstrumentModel.fromJson(Map<String, dynamic> json) =>
      _$InstrumentModelFromJson(json);
}
