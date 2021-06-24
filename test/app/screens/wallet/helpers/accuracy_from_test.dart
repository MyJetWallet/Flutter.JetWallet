import 'package:flutter_test/flutter_test.dart';
import 'package:jetwallet/app/screens/wallet/helper/accuracy_from.dart';
import 'package:jetwallet/service/services/signal_r/model/instruments_model.dart';

void main() {
  test('Accuracy from USD', () async {
    final result = accuracyFrom('USD', instruments);

    expect(result, 2);
  });
  test('Accuracy from BTC', () async {
    final result = accuracyFrom('BTC', instruments);

    expect(result, 8);
  });
}

const instruments = <InstrumentModel>[
  InstrumentModel(
    symbol: '',
    baseAsset: '',
    quoteAsset: 'USD',
    accuracy: 2,
    minVolume: 0,
    maxVolume: 0,
    maxOppositeVolume: 0,
  ),
  InstrumentModel(
    symbol: '',
    baseAsset: '',
    quoteAsset: 'BTC',
    accuracy: 8,
    minVolume: 0,
    maxVolume: 0,
    maxOppositeVolume: 0,
  ),
];
