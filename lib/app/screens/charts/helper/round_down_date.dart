DateTime roundDown(
  DateTime date, {
  Duration delta = const Duration(seconds: 1),
}) {
  return DateTime.fromMillisecondsSinceEpoch(
    date.millisecondsSinceEpoch -
        date.millisecondsSinceEpoch % delta.inMilliseconds,
    isUtc: true,
  );
}
