import 'package:decimal/decimal.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';

extension DecimalExtension on Decimal {
  String toFormatCount({
    int? accuracy,
    String? symbol,
  }) {
    final asset = AssetFormatter(
      decimal: this,
      accuracy: accuracy,
      symbol: symbol,
    );
    return asset.formatCount();
  }

  String toFormatSum({
    int? accuracy,
    String? symbol,
  }) {
    final asset = AssetFormatter(
      decimal: this,
      accuracy: accuracy,
      symbol: symbol,
    );
    return asset.formatSum();
  }

  String toFormatPrice({
    int? accuracy,
    String? prefix,
  }) {
    final asset = AssetFormatter(
      decimal: this,
      accuracy: accuracy,
      prefix: prefix,
    );
    return asset.formatPrice();
  }

  Decimal get negative {
    return this > Decimal.zero ? this * Decimal.parse('-1') : this;
  }
}
