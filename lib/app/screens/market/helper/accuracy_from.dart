import '../../../../service/services/signal_r/model/instruments_model.dart';

int accuracyFrom(String symbol, List<InstrumentModel> instruments) {
  return instruments.where((e) => e.quoteAsset == symbol).first.accuracy;
}
