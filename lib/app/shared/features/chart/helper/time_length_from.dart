import 'package:charts/entity/resolution_string_enum.dart';
import 'package:jetwallet/service/services/chart/model/wallet_history_request_model.dart';

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
  }

  return TimeLength.all;
}
