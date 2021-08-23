import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/providers/signal_r/base_prices_spod.dart';
import '../helper/calculate_percent_change.dart';
import '../model/return_rates_model.dart';

final returnRatesPod = Provider.autoDispose.family<ReturnRatesModel, String>(
  (ref, assetSymbol) {
    final basePrices = ref.watch(basePricesSpod);

    var model = const ReturnRatesModel(
      dayPrice: 0,
      weekPrice: 0,
      monthPrice: 0,
      threeMonthPrice: 0,
    );

    basePrices.whenData((value) {
      final basePrice = value.basePrices.firstWhere(
        (element) => element.assetSymbol == assetSymbol,
      );

      model = model.copyWith(
        dayPrice: basePrice.dayPercentChange,
        weekPrice: calculatePercentOfChange(
          basePrice.weekPrice.price,
          basePrice.currentPrice,
        ),
        monthPrice: calculatePercentOfChange(
          basePrice.monthPrice.price,
          basePrice.currentPrice,
        ),
        threeMonthPrice: calculatePercentOfChange(
          basePrice.threeMonthPrice.price,
          basePrice.currentPrice,
        ),
      );
    });

    return model;
  },
);
