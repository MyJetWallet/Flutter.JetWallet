import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

/// Class for formatting asset counts, prices, and sums according to specified rules.
class AssetFormatter {
  AssetFormatter({
    required this.decimal,
    this.accuracy,
    this.symbol,
    this.prefix,
  }) {
    if (accuracy != null && accuracy!.isNegative) {
      throw ArgumentError('Negative accuracy is not supported');
    }
  }
  final Decimal decimal;
  final int? accuracy;
  final String? symbol;
  final String? prefix;

  /// __Use if you need to format the Asset count__
  ///
  /// Using [decimal] library to fix Floating-point number problem
  ///
  /// `toStringAsFixed(percision)` is not perfect,
  /// it doesn't respect Floating-point numbers.
  /// `(0.015).toStringAsFixed(2)` = 0.01 (which is wrong, expected: 0.02)
  ///
  /// Rules:
  /// 1. if prefix == null {price} {symbol}
  /// 2. thousands are seperated by whitespace like that 1 000 000
  /// 3. decimal is divided by '.' like that 1 000.00
  /// 4. decimal should be rounded to provided accuracy
  ///    Example when accuracy is 3: 1 000.1283192 => 1 000.128
  /// 5. rounding should be mathematical
  /// 6. zeros must be truncated
  ///    Example when accuracy is 3: 1 000.000 => 1 000
  ///    Example when accuracy is 3: 1 000.100 => 1 000.1
  /// 6. zero case: 0 => 0, 0.00 => 0
  String formatCount() {
    final formatted = _formatNumber(number: decimal, accuracy: accuracy, fillAccuracy: false);
    final formattedWithSymbol = '$formatted ${symbol ?? ''}'.trim();
    return decimal.signum.isNegative ? '-$formattedWithSymbol' : formattedWithSymbol;
  }

  /// __Use if you need to format the Asset price__
  ///
  /// Using [Decimal] library to fix Floating-point number problem
  ///
  /// `toStringAsFixed(percision)` is not perfect,
  /// it doesn't respect Floating-point numbers.
  /// `(0.015).toStringAsFixed(2)` = 0.01 (which is wrong, expected: 0.02)
  ///
  /// Rules:
  /// 1. if prefix != null {prefix} {price}
  /// 2. thousands are seperated by whitespace like that 1 000 000
  /// 3. decimal is divided by '.' like that 1 000.00
  /// 4. decimal should be rounded to provided accuracy
  ///    Example when accuracy is 3: 1 000.1283192 => 1 000.128
  /// 5. rounding should be mathematical
  /// 6. zeros must not be truncated
  ///    Example when accuracy is 3: 1 000.000 => 1 000.000
  ///    Example when accuracy is 3: 1 000.100 => 1 000.100
  /// 7. zero case: 0 => 0, 0.00 => 0
  String formatPrice() {
    final formatted = _formatNumber(number: decimal, accuracy: accuracy, fillAccuracy: true);
    final formattedWithSignum = decimal.signum.isNegative ? '-$formatted' : formatted;
    final formattedWithPrefix = '${prefix ?? ''} $formattedWithSignum'.trim();
    return formattedWithPrefix;
  }

  /// __Use if you need to format the value of the asset__
  ///
  /// Using [decimal] library to fix Floating-point number problem
  ///
  /// `toStringAsFixed(percision)` is not perfect,
  /// it doesn't respect Floating-point numbers.
  /// `(0.015).toStringAsFixed(2)` = 0.01 (which is wrong, expected: 0.02)
  ///
  /// Rules:
  /// 1. if prefix != null {prefix}{price}
  /// 2. if prefix == null {price} {symbol}
  /// 3. thousands are seperated by whitespace like that 1 000 000
  /// 4. decimal is divided by '.' like that 1 000.00
  /// 5. decimal should be rounded to provided accuracy
  ///    Example when accuracy is 3: 1 000.1283192 => 1 000.128
  /// 6. rounding should be mathematical
  /// 7. zeros must not be truncated
  ///    Example when accuracy is 3: 1 000.000 => 1 000.000
  ///    Example when accuracy is 3: 1 000.100 => 1 000.100
  /// 8. zero case: 0 => 0, 0.00 => 0
  String formatSum() {
    final formatted = _formatNumber(number: decimal, accuracy: accuracy, fillAccuracy: true);
    final formattedWithSymbol = '$formatted ${symbol ?? ''}'.trim();
    return decimal.signum.isNegative ? '-$formattedWithSymbol' : formattedWithSymbol;
  }

  String _formatNumber({required Decimal number, int? accuracy, required bool fillAccuracy}) {
    if (number == Decimal.zero) return '0';

    final absNumber = number.abs();
    final rounded = accuracy != null ? absNumber.round(scale: accuracy) : absNumber;

    final numberParts = rounded.toString().split('.');
    final wholePart = numberParts[0];
    final decimalPart = numberParts.length > 1 ? numberParts[1] : '';

    final formattedWholePart = _formatWholePart(wholePart);

    if (fillAccuracy) {
      final truncatedDecimalPart = _addZeros(decimalPart: decimalPart, accuracy: accuracy);
      return truncatedDecimalPart.isEmpty ? formattedWholePart : '$formattedWholePart.$truncatedDecimalPart';
    } else {
      return decimalPart.isEmpty ? formattedWholePart : '$formattedWholePart.$decimalPart';
    }
  }

  String _formatWholePart(String wholePart) {
    final formatter = NumberFormat.decimalPattern();
    final wholePartInt = int.tryParse(wholePart) ?? 0;
    return formatter.format(wholePartInt).replaceAll(',', ' ');
  }

  String _addZeros({
    required String decimalPart,
    required int? accuracy,
  }) {
    if (accuracy != null && decimalPart.length < accuracy) {
      final requiredZeros = '0' * (accuracy - decimalPart.length);
      return decimalPart + requiredZeros;
    } else {
      return decimalPart;
    }
  }
}
