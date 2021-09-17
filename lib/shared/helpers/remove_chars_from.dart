String removeCharsFrom(String string, int amount) {
  if (string.isEmpty) return '';
  return string.substring(0, string.length - amount);
}
