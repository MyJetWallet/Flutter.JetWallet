import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/price_accuracies.dart';

import '../signal_r/price_accuracies_spod.dart';

final priceAccuraciesPod = Provider.autoDispose<List<PriceAccuracy>>(
  (ref) {
    final stream = ref.watch(priceAccuraciesSpod);

    final array = <PriceAccuracy>[];

    stream.whenData((data) {
      final accuracies = data.accuracies;

      for (final accuracy in accuracies) {
        array.add(accuracy);
      }
    });

    return array;
  },
  name: 'convertPriceAccuraciesPod',
);
