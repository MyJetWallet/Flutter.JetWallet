String formatPercent(double percent) {
  if (percent.compareTo(0) == 0) {
    return '0.0%';
  } else if (percent.isNegative) {
    return '$percent%';
  } else {
    return '+$percent%';
  }
}
