mixin NumberUtil {
  static String volFormat(double n) {
    if (n > 10000 && n < 999999) {
      final d = n / 1000;
      return '${d.toStringAsFixed(2)}K';
    } else if (n > 1000000) {
      final d = n / 1000000;
      return '${d.toStringAsFixed(2)}M';
    }
    return n.toStringAsFixed(2);
  }

  static int _fractionDigits = 2;

  static set fractionDigits(int value) {
    if (value != _fractionDigits) _fractionDigits = value;
  }

  static String format(double price) {
    return price.toStringAsFixed(_fractionDigits);
  }
}
