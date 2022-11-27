import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/capitalize_text.dart';

String sortWordDependingLang({
  required String text,
  required String swappedText,
  required String languageCode,
  bool isCapitalize = false,
}) {
  return languageCode == languageCodePl
      ? '${isCapitalize ? capitalizeText(swappedText) : swappedText}' ' $text'
      : '$text $swappedText';
}
