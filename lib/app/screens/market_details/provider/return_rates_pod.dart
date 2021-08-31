import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../../shared/providers/signal_r/period_prices_spod.dart';
import '../helper/calculate_percent_change.dart';
import '../model/return_rates_model.dart';

final returnRatesPod = Provider.autoDispose.family<ReturnRatesModel, String>(
  (ref, assetSymbol) {
    final periodPrices = ref.watch(periodPricesSpod);
    final currencies = ref.read(currenciesPod);

    var model = const ReturnRatesModel();

    periodPrices.whenData((value) {
      final periodPrice = value.prices.firstWhere(
        (element) => element.assetSymbol == assetSymbol,
      );
      final currency = currencies.firstWhere(
        (element) => element.symbol == assetSymbol,
      );

      model = model.copyWith(
        dayPrice: calculatePercentOfChange(
          periodPrice.dayPrice.price,
          currency.currentPrice,
        ),
        weekPrice: calculatePercentOfChange(
          periodPrice.weekPrice.price,
          currency.currentPrice,
        ),
        monthPrice: calculatePercentOfChange(
          periodPrice.monthPrice.price,
          currency.currentPrice,
        ),
        threeMonthPrice: calculatePercentOfChange(
          periodPrice.threeMonthPrice.price,
          currency.currentPrice,
        ),
      );
    });

    return model;
  },
);
