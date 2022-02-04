/// Removes cases like:
/// 1) 50.0000 -> 50
/// 2) 4.3320000 -> 4.332
String truncateZerosFrom(String number) {
  final parsed = double.tryParse(number);

  if (parsed == null) {
    return number;
  }

  if (parsed == 0) {
    return '0';
  }

  if (parsed % 1 == 0) {
    return parsed.toInt().toString();
  } else {
    return parsed.toString();
  }
}
