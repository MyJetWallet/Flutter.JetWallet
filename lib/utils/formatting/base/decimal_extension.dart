import 'package:decimal/decimal.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';

extension DecimalExtension on Decimal {
  String toFormatCount({
    required int accuracy,
    required String symbol,
  }) {
    final asset = AssetFormatter(
      decimal: this,
      accuracy: accuracy,
      symbol: symbol,
    );
    return asset.formatCount();
  }

  String toFormatSum({
    required int accuracy,
    required String symbol,
  }) {
    final asset = AssetFormatter(
      decimal: this,
      accuracy: accuracy,
      symbol: symbol,
    );
    return asset.formatSum();
  }

  String toFormatPrice({
    required int accuracy,
    required String prefix,
  }) {
    final asset = AssetFormatter(
      decimal: this,
      accuracy: accuracy,
      prefix: prefix,
    );
    return asset.formatSum();
  }

  Decimal get negative {
    return this > Decimal.zero ? this * Decimal.parse('-1') : this;
  }
}
