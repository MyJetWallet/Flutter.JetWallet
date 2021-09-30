enum PinLockEnum {
  none,
  one,
  five,
  thirty,
  oneHour,
  twoHours,
}

extension PinRetryLockExtension on PinLockEnum {
  int get seconds {
    switch (this) {
      case PinLockEnum.none:
        return 0;
      case PinLockEnum.one:
        return 60;
      case PinLockEnum.five:
        return 300;
      case PinLockEnum.thirty:
        return 1800;
      case PinLockEnum.oneHour:
        return 3600;
      case PinLockEnum.twoHours:
        return 7200;
    }
  }
}
