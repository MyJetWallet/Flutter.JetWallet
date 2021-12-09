import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../../providers/signal_r/period_prices_spod.dart';
import '../helper/calculate_percent_change.dart';
import '../model/return_rates_model.dart';

final returnRatesPod =
    Provider.autoDispose.family<ReturnRatesModel, ReturnRatesModel1>(
  (ref, returnRates1) {
    final periodPrices = ref.watch(periodPricesSpod);
    final currencies = ref.read(currenciesPod);

    var model = const ReturnRatesModel();

    periodPrices.whenData((value) {
      final periodPrice = value.prices.firstWhere(
        (element) =>
            element.assetSymbol ==
            returnRates1.pair.substring(0, returnRates1.pair.length - 2),
      );
      final currency = currencies.firstWhere(
        (element) => element.symbol == returnRates1.asset,
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

class ReturnRatesModel1 {
  ReturnRatesModel1(
    this.asset,
    this.pair,
  );

  final String asset;
  final String pair;
}
