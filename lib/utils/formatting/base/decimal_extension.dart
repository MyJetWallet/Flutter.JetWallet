import 'package:decimal/decimal.dart';

import '../formatting.dart';

extension DecimalExtension on Decimal {
  String toMarketFormat({
    String? prefix,
    required int accuracy,
    required String symbol,
  }) {
    return marketFormat(
      prefix: prefix,
      accuracy: accuracy,
      symbol: symbol,
      decimal: this,
    );
  }

  String toVolumeFormat({
    String? prefix,
    required int accuracy,
    required String symbol,
  }) {
    return volumeFormat(
      prefix: prefix,
      accuracy: accuracy,
      symbol: symbol,
      decimal: this,
    );
  }
}
