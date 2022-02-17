import '../../../../service/shared/constants.dart';

// TODO(any): move to shared helper or remove
String formatDayPercentageChange(double change) {
  final formattedChange = change.toStringAsFixed(signsAfterComma);

  if (change == 0) {
    return '0%';
  } else if (change > 0) {
    return '+$formattedChange%';
  } else {
    return '$formattedChange%';
  }
}
