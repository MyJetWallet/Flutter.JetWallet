import '../../../shared/services/remote_config_service/remote_config_values.dart';

String iconUrlFrom(String assetSymbol) {
  return '$iconApi/${assetSymbol.toLowerCase()}.svg';
}
