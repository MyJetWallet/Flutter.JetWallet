import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../model/return_rates_model.dart';
import 'base_prices_spod.dart';

final returnRatesPod =
    Provider.autoDispose.family<ReturnRatesModel, String>((ref, instrument) {
  final basePrices = ref.watch(basePricesSpod);
  const model = ReturnRatesModel(
    dayPrice: 0,
    weekPrice: 0,
    monthPrice: 0,
    threeMonthPrice: 0,
  );

  basePrices.whenData((value) {
    final assetBasePrice = value.basePrices
        .firstWhere((element) => element.instrumentSymbol == instrument);
    model.copyWith(
      dayPrice: assetBasePrice.dayPrice.price,
      weekPrice: assetBasePrice.weekPrice.price,
      monthPrice: assetBasePrice.monthPrice.price,
      threeMonthPrice: assetBasePrice.threeMonthPrice.price,
    );
  });

  return model;
});
