class Period {
  static const String hour = '1H';
  static const String day = '1D';
  static const String week = '1W';
  static const String month = '1M';
  static const String year = '1Y';
  static const String all = 'All';
}

// 0 - minutes
// 1 - hours
// 2 - days
// 3 - months
class Timeframe {
  static const int hour = 0;
  static const int day = 0;
  static const int week = 1;
  static const int month = 1;
  static const int year = 2;
  static const int all = 2;
}

class MergeCandlesCount {
  static const int hour = 0;
  static const int day = 15;
  static const int week = 2;
  static const int month = 8;
  static const int year = 4;
  static const int all = 7;
}
