bool isCardExpired(int month, int year) {
  final now = DateTime.now();
  final nowMonth = now.month;
  final nowYear = now.year;

  if (nowYear > year) {
    return true;
  } else if (nowYear == year) {
    if (nowMonth > month) {
      return true;
    }
  }

  return false;
}
