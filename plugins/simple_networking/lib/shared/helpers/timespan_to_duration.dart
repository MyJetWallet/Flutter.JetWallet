/// Returns [absolute] duration with percision to seconds
/// timespan: [days.hours:minutes:seconds.ticks]
Duration timespanToDuration(String timespan) {
  var absTimespan = timespan;

  if (timespan[0] == '-') {
    absTimespan = timespan.substring(1);
  }

  final split = absTimespan.split(':');

  final part1 = split[0];
  final part2 = split[1];
  final part3 = split[2];

  final splitPart1 = part1.split('.');
  final splitPart3 = part3.split('.');

  return Duration(
    days: splitPart1.length == 1 ? 0 : int.parse(splitPart1[0]),
    hours: int.parse(splitPart1.length == 1 ? splitPart1[0] : splitPart1[1]),
    minutes: int.parse(part2),
    seconds: int.parse(splitPart3[0]),
  );
}
