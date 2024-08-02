import '../../../utils/enum.dart';

int getDaysByPeriod(InvestHistoryPeriod value) {
  switch (value) {
    case InvestHistoryPeriod.week:
      return 7;
    case InvestHistoryPeriod.oneMonth:
      return 30;
    case InvestHistoryPeriod.twoMonth:
      return 60;
    case InvestHistoryPeriod.threeMonth:
      return 90;
    default:
      return 7;
  }
}
