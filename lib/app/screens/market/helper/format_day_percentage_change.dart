import '../../../../service/shared/constants.dart';

// TODO(any): move to shared helper or remove
String formatDayPercentageChange(double change) {
  final formattedChange = change.toStringAsFixed(signsAfterComma);

  return change > 0 ? '+$formattedChange%' : '$formattedChange%';
}
