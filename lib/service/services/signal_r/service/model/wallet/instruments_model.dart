import 'package:freezed_annotation/freezed_annotation.dart';

part 'instruments_model.freezed.dart';
part 'instruments_model.g.dart';

@freezed
class InstrumentsModel with _$InstrumentsModel {
  const factory InstrumentsModel({
    required double now,
    required List<InstrumentModel> spotInstruments,
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
    required double minVolume,
    required double maxVolume,
    required double maxOppositeVolume,
  }) = _InstrumentModel;

  factory InstrumentModel.fromJson(Map<String, dynamic> json) =>
      _$InstrumentModelFromJson(json);
}
