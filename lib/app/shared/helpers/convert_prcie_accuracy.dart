import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../service/services/signal_r/model/convert_price_accuracies.dart';
import '../providers/convert_price_accuracies_pod/convert_price_accuarcies_pod.dart';

int convertPriceAccuracy(Reader read, String from, String to) {
  final accuracies = read(convertPriceAccuraciesPod);

  final accuarcy = accuracies.firstWhere(
    (element) {
      return element.from == from && element.to == to;
    },
    orElse: () {
      return const ConvertPriceAccuracy(from: '', to: '', accuracy: 0);
    },
  );

  return accuarcy.accuracy;
}
