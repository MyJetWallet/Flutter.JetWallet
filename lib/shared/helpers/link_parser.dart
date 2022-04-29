Map<String, String> linkParser(String textToParse) {
  var stringToParse = textToParse;
  var previousLink = '';
  final parsedData = <String, String>{};

  do {
    final divider = stringToParse.indexOf('\$\$');
    var text = '';

    if (divider != -1) {
      text = stringToParse.substring(0, divider);
    } else {
      parsedData.putIfAbsent(stringToParse, () => '');
      return parsedData;
    }

    if (previousLink.isNotEmpty) {
      parsedData[previousLink] = text;
    } else {
      parsedData.putIfAbsent(text, () => '');
    }
    if (text.contains('http')) {
      previousLink = text;
    } else {
      previousLink = '';
    }
    stringToParse =
        stringToParse.substring(divider + 2, stringToParse.length);
  } while (true);
}
