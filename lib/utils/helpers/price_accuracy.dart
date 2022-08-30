import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:simple_networking/modules/signal_r/models/price_accuracies.dart';

int priceAccuracy(String from, String to) {
  final accuracies = sSignalRModules.priceAccuracies;

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
