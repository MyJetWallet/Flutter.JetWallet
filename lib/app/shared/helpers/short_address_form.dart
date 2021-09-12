/// Converts cryptoAddress to [xxxx **** xxxx] format
String shortAddressForm(String address) {
  final length = address.length;

  if (length <= 8) return address;

  final part1 = address.substring(0, 4);
  final part2 = address.substring(length - 4, length);

  return '$part1 **** $part2';
}
