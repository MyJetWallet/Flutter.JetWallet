import '../../../../../shared/constants.dart';
import '../../../../../shared/helpers/capitalize_text.dart';

String sortWordDependingLang({
  required String text,
  required String swappedText,
  required String languageCode,
  bool isCapitalize = false,
}) {
  if (languageCode == languageCodePl) {
    return '${isCapitalize ? capitalizeText(swappedText) : swappedText}'' $text';
  } else {
    return '$text $swappedText';
  }
}