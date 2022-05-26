import 'package:simple_networking/shared/api_urls.dart';

String iconUrlFrom({
  required String assetSymbol,
  bool selected = false,
}) {
  return '$iconApi/${assetSymbol.toLowerCase()}${selected ? '_selected' : ''}.svg';
}
