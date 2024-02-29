int chartResolutionHelper(int resolution) {
  switch (resolution) {
    case 0:
      return 0;
    case 1:
      return 0;
    case 2:
      return 1;
    case 3:
      return 2;
    default:
      return 0;
  }
}

int chartIntervalHelper(int resolution) {
  switch (resolution) {
    case 0:
      return 1;
    case 1:
      return 1;
    case 2:
      return 1;
    case 3:
      return 1;
    default:
      return 1;
  }
}

int chartDateToHelper(int resolution) {
  switch (resolution) {
    case 0:
      return DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch;
    case 1:
      return DateTime.now().subtract(const Duration(days: 5)).millisecondsSinceEpoch;
    case 2:
      return DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch;
    case 3:
      return DateTime.now().subtract(const Duration(days: 90)).millisecondsSinceEpoch;
    default:
      return 0;
  }
}

String chartResolutionTypeHelper(int resolution) {
  switch (resolution) {
    case 0:
      return '15';
    case 1:
      return '60';
    case 2:
      return '240';
    case 3:
      return '1D';
    default:
      return '15';
  }
}
