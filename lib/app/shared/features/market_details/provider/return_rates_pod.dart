import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../../providers/signal_r/period_prices_spod.dart';
import '../helper/calculate_percent_change.dart';
import '../model/return_rates_model.dart';

final returnRatesPod = Provider.autoDispose.family<ReturnRatesModel, String>(
  (ref, assetId) {
    final periodPrices = ref.watch(periodPricesSpod);
    final currencies = ref.read(currenciesPod);

    var model = const ReturnRatesModel();

    periodPrices.whenData((value) {
      final periodPrice = value.prices.firstWhere(
        (element) => element.assetSymbol == assetId,
      );
      final currency = currencies.firstWhere(
        (element) => element.symbol == assetId,
      );

      model = model.copyWith(
        dayPrice: calculatePercentOfChange(
          periodPrice.dayPrice.price.toDouble(),
          currency.currentPrice.toDouble(),
        ),
        weekPrice: calculatePercentOfChange(
          periodPrice.weekPrice.price.toDouble(),
          currency.currentPrice.toDouble(),
        ),
        monthPrice: calculatePercentOfChange(
          periodPrice.monthPrice.price.toDouble(),
          currency.currentPrice.toDouble(),
        ),
        threeMonthPrice: calculatePercentOfChange(
          periodPrice.threeMonthPrice.price.toDouble(),
          currency.currentPrice.toDouble(),
        ),
      );
    });

    return model;
  },
);
