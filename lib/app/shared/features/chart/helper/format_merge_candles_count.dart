import 'package:charts/simple_chart.dart';

int mergeCandlesCountFrom(String resolution) {
  if (resolution == Period.hour) {
    return MergeCandlesCount.hour;
  } else if (resolution == Period.day) {
    return MergeCandlesCount.day;
  } else if (resolution == Period.week) {
    return MergeCandlesCount.week;
  } else if (resolution == Period.month) {
    return MergeCandlesCount.month;
  } else if (resolution == Period.year) {
    return MergeCandlesCount.year;
  }

  return MergeCandlesCount.day;
}
