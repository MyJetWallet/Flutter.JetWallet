import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

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
/// 8. zero case: 0 => 0.00, 0.00 => 0.00
String marketFormat({
  @Deprecated('The parameter is not used')
  String? prefix,
  bool? onlyFullPart,
  required Decimal decimal,
  required int accuracy,
  required String symbol,
}) {
  if (accuracy.isNegative) {
    throw ArgumentError(
      'marketFormat() does not support negative accuracy',
    );
  }

  final formatted = _formatNumber(decimal, accuracy, onlyFullPart);

  late String formattedWithSymbol;

  formattedWithSymbol = '$formatted $symbol';
  //prefix == null ? '$formatted $symbol' : '$prefix$formatted';

  return decimal.signum.isNegative
      ? '-$formattedWithSymbol'
      : formattedWithSymbol;
}

String _formatNumber(Decimal number, int accuracy, bool? onlyFullPart) {
  final absNumber = number.abs();

  final rounded = absNumber.round(scale: accuracy);

  final chars = rounded.toString().split('');

  final wholePart = StringBuffer();
  final decimalPart = StringBuffer();

  var beforeDecimal = true;

  for (final char in chars) {
    if (char == '.') {
      beforeDecimal = false;
      continue;
    }
    if (beforeDecimal) {
      wholePart.write(char);
    } else {
      decimalPart.write(char);
    }
  }

  final formatter = NumberFormat.decimalPattern();

  final wholePart2 = int.parse(wholePart.toString());
  final wholePart3 = formatter.format(wholePart2).replaceAll(',', ' ');

  if (accuracy == 0 || (onlyFullPart != null && onlyFullPart)) {
    return wholePart3;
  }

  while (decimalPart.length < accuracy) {
    decimalPart.write('0');
  }

  return '$wholePart3.$decimalPart';
}
