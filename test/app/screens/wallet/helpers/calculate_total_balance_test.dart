import 'package:flutter_test/flutter_test.dart';
import 'package:jetwallet/app/screens/wallet/helpers/calculate_total_balance.dart';
import 'package:jetwallet/app/screens/wallet/models/currency_model.dart';

void main() {
  test('Calculate total balance', () async {
    final result = calculateTotalBalance(2, currencies);

    expect(result, 431446.31);
  });
}

const currencies = <CurrencyModel>[
  CurrencyModel(
    symbol: 'EUR',
    description: 'Euro',
    accuracy: 2.0,
    depositMode: 1,
    withdrawalMode: 1,
    tagType: 0,
    assetId: 'EUR',
    reserve: 0.0,
    lastUpdate: '',
    sequenceId: 0.0,
    assetBalance: 20000.0,
    baseBalance: 7500.0,
  ),
  CurrencyModel(
    symbol: 'BTC',
    description: 'Bitcoin',
    accuracy: 8.0,
    depositMode: 1,
    withdrawalMode: 1,
    tagType: 0,
    assetId: 'BTC',
    reserve: 0.0,
    lastUpdate: '',
    sequenceId: 0.0,
    assetBalance: 25.0,
    baseBalance: 370382.0,
  ),
  CurrencyModel(
    symbol: 'USD',
    description: 'US Dollar',
    accuracy: 2.0,
    depositMode: 1,
    withdrawalMode: 1,
    tagType: 0,
    assetId: 'USD',
    reserve: 0.0,
    lastUpdate: '',
    sequenceId: 0.0,
    assetBalance: 53564.31,
    baseBalance: 53564.31,
  ),
];
