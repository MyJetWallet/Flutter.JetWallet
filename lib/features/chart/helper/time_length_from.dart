import 'package:charts/simple_chart.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet_history/wallet_history_request_model.dart';

TimeLength timeLengthFrom(String resolution) {
  if (resolution == Period.hour) {
    return TimeLength.day;
  } else if (resolution == Period.day) {
    return TimeLength.day;
  } else if (resolution == Period.week) {
    return TimeLength.week;
  } else if (resolution == Period.month) {
    return TimeLength.month;
  } else if (resolution == Period.year) {
    return TimeLength.year;
  } else if (resolution == Period.all) {
    return TimeLength.all;
  }

  return TimeLength.day;
}
