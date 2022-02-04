import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/convert_price_accuracies.dart';
import '../signal_r/convert_price_accuracies_spod.dart';

final convertPriceAccuraciesPod =
    Provider.autoDispose<List<ConvertPriceAccuracy>>(
  (ref) {
    final stream = ref.watch(convertPriceAccuraciesSpod);

    final array = <ConvertPriceAccuracy>[];

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
