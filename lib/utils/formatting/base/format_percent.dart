extension FormatPercentExtension on double {
  String toFormatPercentPriceChange() {
    if (compareTo(0) == 0) {
      return '0.00%';
    } else if (isNegative) {
      return '${toStringAsFixed(2)}%';
    } else {
      return '+${toStringAsFixed(2)}%';
    }
  }

  String toFormatPercentCount() {
    return '${toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}%';
  }
}
