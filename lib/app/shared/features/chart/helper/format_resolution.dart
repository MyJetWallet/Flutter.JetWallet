import 'package:charts/entity/resolution_string_enum.dart';

int timeFrameFrom(String resolution) {
  if (resolution == Period.hour) {
    return Timeframe.hour;
  } else if (resolution == Period.day) {
    return Timeframe.day;
  } else if (resolution == Period.week) {
    return Timeframe.week;
  } else if (resolution == Period.month) {
    return Timeframe.month;
  } else if (resolution == Period.year) {
    return Timeframe.year;
  }

  return Timeframe.day;
}