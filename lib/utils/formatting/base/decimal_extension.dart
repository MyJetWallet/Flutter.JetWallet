import 'package:decimal/decimal.dart';

import '../formatting.dart';

extension DecimalExtension on Decimal {
  String toMarketFormat({
    required int accuracy,
    required String symbol,
  }) {
    return marketFormat(
      accuracy: accuracy,
      symbol: symbol,
      decimal: this,
    );
  }

  String toVolumeFormat({
    required int accuracy,
    required String symbol,
  }) {
    return volumeFormat(
      accuracy: accuracy,
      symbol: symbol,
      decimal: this,
    );
  }
}
