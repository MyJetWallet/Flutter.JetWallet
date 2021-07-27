import '../../../../service/shared/constants.dart';

String formatDayPercentageChange(double change) {
  final formattedChange = change.toStringAsFixed(signsAfterComma);

  return change > 0 ? '+$formattedChange%' : '$formattedChange%';
}
