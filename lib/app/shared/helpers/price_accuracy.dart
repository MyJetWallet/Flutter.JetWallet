import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../service/services/signal_r/model/price_accuracies.dart';
import '../providers/price_accuracies_pod/price_accuarcies_pod.dart';

int priceAccuracy(Reader read, String from, String to) {
  final accuracies = read(priceAccuraciesPod);

  final accuarcy = accuracies.firstWhere(
    (element) {
      return element.from == from && element.to == to;
    },
    orElse: () {
      return const PriceAccuracy(from: '', to: '', accuracy: 8);
    },
  );

  return accuarcy.accuracy;
}
