import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../helpers/calculate_base_balance.dart';
import '../../../helpers/formatting/base/volume_format.dart';
import '../../../models/recurring_buys_model.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../helper/recurring_buys_status_name.dart';
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

  RecurringBuysStatus type(String symbol) {
    final recurringBuysList = _recurringBuyAssetList(symbol);

    if (recurringBuysList.isNotEmpty) {
      final activeRecurringBuysList = recurringBuysList
          .where((element) => element.status == RecurringBuysStatus.active);

      if (activeRecurringBuysList.isNotEmpty) {
        return RecurringBuysStatus.active;
      }

      final pausedRecurringBuysList = recurringBuysList
          .where((element) => element.status == RecurringBuysStatus.paused);

      if (pausedRecurringBuysList.isNotEmpty &&
          pausedRecurringBuysList.length == recurringBuysList.length) {
        return RecurringBuysStatus.paused;
      }
    }

    return RecurringBuysStatus.empty;
  }

  List<RecurringBuysModel> _recurringBuyAssetList(String asset) {
    final list = <RecurringBuysModel>[];
    for (final element in state.recurringBuys) {
      if (element.toAsset == asset) {
        list.add(element);
      }
    }

    return list;
  }

  String total({
    required String asset,
  }) {
    final currencies = read(currenciesPod);
    final baseCurrency = read(baseCurrencyPod);

    var accumulate = Decimal.zero;
    for (final element in state.recurringBuys) {
      if (element.toAsset == asset) {
        for (final currency in currencies) {
          if (currency.symbol == element.fromAsset) {
            accumulate += _convertToUsd(element.toAsset, element.fromAmount!);
          }
        }
      }
    }

    final total = _priceVolumeFormat(accumulate);

    return '${baseCurrency.prefix}$total';
  }

  String price({
    required String asset,
    required double amount,
  }) {
    final baseCurrency = read(baseCurrencyPod);
    final assetBasePriceInUsd = _convertToUsd(asset, amount);

    final priceInUsd = _priceVolumeFormat(assetBasePriceInUsd);

    return '${baseCurrency.prefix}$priceInUsd';
  }

  String _priceVolumeFormat(Decimal amount) {
    final priceInUsd = volumeFormat(
      decimal: amount,
      accuracy: 0,
      symbol: '',
    );

    return priceInUsd;
  }

  Decimal _convertToUsd(String asset, double amount) {
    final assetBasePriceInUsd = calculateBaseBalanceWithReader(
      read: read,
      assetSymbol: asset,
      assetBalance: Decimal.parse('$amount'),
    );

    return assetBasePriceInUsd;
  }
}
