import 'package:decimal/decimal.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';

extension DecimalExtension on Decimal {
  /// Trims zeros at the end of the fractional part and adds a symbol at the end.
  /// Usually used for the number of assets in the currency of the asset
  ///
  ///   Examples: 1 000.234122 BTS, 122 BTC
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

  /// Leaves zeros at the end of the fractional part and adds a symbol at the end.
  /// Usually used for the amount of asset in the base currency.
  ///
  ///  Examples: 1 000.00 EUR, 122.10 USD
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

  /// Trims zeroes at the end of the fractional part and adds a prefix at the beginning.
  /// Usually used to price a unit of an asset in the base currency.
  ///
  ///  Examples: € 1 000.00, $ 122.10
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

  String toFormatPercentPriceChange() {
    return toDouble().toFormatPercentPriceChange();
  }

  String toFormatPercentCount() {
    return toDouble().toFormatPercentCount();
  }
}
