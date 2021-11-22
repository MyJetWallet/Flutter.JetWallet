import '../entity/custom_resolution_enum.dart';
import '../entity/resolution_string_entity.dart';
import '../entity/resolution_string_enum.dart';

mixin DataFeedUtil {
  static ResolutionForServerEnum parseCandleType(String resolution) {
    switch (resolution) {
      case Period.hour:
        return ResolutionForServerEnum.hour;
      case Period.day:
        return ResolutionForServerEnum.day;
      case Period.month:
        return ResolutionForServerEnum.month;
      default:
        return ResolutionForServerEnum.day;
    }
  }

  static ResolutionBackValues calculateHistoryDepth(String resolution) {
    switch (resolution) {
      case Period.hour:
        return ResolutionBackValues(Period.hour, const Duration(hours: 1));

      case Period.day:
        return ResolutionBackValues(Period.day, const Duration(days: 1));

      case Period.week:
        return ResolutionBackValues(Period.week, const Duration(days: 7));

      case Period.month:
        return ResolutionBackValues(Period.month, const Duration(days: 30));

      case Period.year:
        return ResolutionBackValues(Period.year, const Duration(days: 365));

      default:
        return ResolutionBackValues(resolution, const Duration(hours: 2));
    }
  }
}
