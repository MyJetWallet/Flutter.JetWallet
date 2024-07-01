import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String formatNumber() {
    final formatter = NumberFormat.decimalPattern();

    return formatter.format(this).replaceAll(',', ' ');
  }
}
