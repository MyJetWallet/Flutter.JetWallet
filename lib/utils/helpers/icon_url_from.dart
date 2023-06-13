import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';

String iconUrlFrom({
  required String assetSymbol,
  bool selected = false,
}) {
  final iconApi = sNetwork.options.iconApi;

  return '$iconApi/${assetSymbol.toLowerCase()}${selected ? '_selected' : ''}.svg';
}

String iconForPaymentMethod({
  required String methodId,
}) {
  final iconApi =
      sNetwork.options.iconApi!.replaceAll('icons', 'resources/content');

  return '$iconApi/$methodId.svg';
}
