import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../helpers/calculate_base_balance.dart';
import '../../../models/recurring_buys_model.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import 'recurring_buys_state.dart';

class RecurringBuysNotifier extends StateNotifier<RecurringBuysState> {
  RecurringBuysNotifier(
    this.read,
    this.recurringBuys,
  ) : super(
          const RecurringBuysState(
            recurringBuys: <RecurringBuysModel>[],
          ),
        ) {
    _init();
  }

  final Reader read;
  final List<RecurringBuysModel> recurringBuys;

  void _init() {
    state = state.copyWith(recurringBuys: [...recurringBuys]);
  }

  String total(String asset) {
    final currencies = read(currenciesPod);

    var total = 0.0;
    for (final element in state.recurringBuys) {
      if (element.toAsset == asset) {
        for (final currency in currencies) {
          if (currency.symbol == element.fromAsset) {
            total += convertToUsd(element.toAsset, element.fromAmount!);
          }
        }
      }
    }

    return '\$${total.toStringAsFixed(0)}';
  }

  double convertToUsd(String asset, double amount) {
    final assetBasePriceInUsd = calculateBaseBalanceWithReader(
      read: read,
        assetSymbol: asset,
      assetBalance: Decimal.parse('$amount'),
    );

    return assetBasePriceInUsd.toDouble();
  }
}
