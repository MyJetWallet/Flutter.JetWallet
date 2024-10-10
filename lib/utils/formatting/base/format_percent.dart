extension FormatPercentExtension on double {
  /// Formats a double value representing price change percentages
  ///
  /// Example:
  /// 3.456 -> "+3.46%"
  /// -1.234 -> "-1.23%"
  /// 0.0 -> "0.00%"
  String toFormatPercentPriceChange() {
    if (compareTo(0) == 0) {
      return '+0.00%';
    } else if (isNegative) {
      return '${toStringAsFixed(2)}%';
    } else {
      return '+${toStringAsFixed(2)}%';
    }
  }

  /// Formats a double value to a percentage representation
  /// with trimmed unnecessary decimal places.
  ///
  /// Example:
  /// 45.50 -> "45.5%"
  /// -10.0 -> "-10%"
  /// 0.0 -> "0%"
  String toFormatPercentCount() {
    return '${toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}%';
  }
}
