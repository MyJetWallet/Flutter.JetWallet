import '../../../shared/services/remote_config_service/remote_config_values.dart';

String iconUrlFrom({
  required String assetSymbol,
  bool selected = false,
}) {
  return '$iconApi/${assetSymbol.toLowerCase()}${selected ? '_selected' : ''}.svg';
}
