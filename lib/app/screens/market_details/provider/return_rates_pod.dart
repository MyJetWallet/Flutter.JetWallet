import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../helper/calculate_percent_change.dart';
import '../model/return_rates_model.dart';
import 'base_prices_spod.dart';

final returnRatesPod =
    Provider.autoDispose.family<ReturnRatesModel, String>((ref, instrument) {
  final basePrices = ref.watch(basePricesSpod);

  var model = const ReturnRatesModel(
    dayPrice: 0,
    weekPrice: 0,
    monthPrice: 0,
    threeMonthPrice: 0,
  );

  basePrices.whenData((value) {
    final assetBasePrice = value.basePrices
        .firstWhere((element) => element.instrumentSymbol == instrument);

    model = model.copyWith(
      dayPrice: assetBasePrice.dayPercentChange,
      weekPrice: calculatePercentOfChange(
        assetBasePrice.weekPrice.price,
        assetBasePrice.currentPrice,
      ),
      monthPrice: calculatePercentOfChange(
        assetBasePrice.monthPrice.price,
        assetBasePrice.currentPrice,
      ),
      threeMonthPrice: calculatePercentOfChange(
        assetBasePrice.threeMonthPrice.price,
        assetBasePrice.currentPrice,
      ),
    );
  });

  return model;
});
