import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';

String iconUrlFrom({
  required String assetSymbol,
  String? api,
  bool selected = false,
}) {
  final iconApi = api ?? sNetwork.options.iconApi;

  return '$iconApi/${assetSymbol.toLowerCase()}${selected ? '_selected' : ''}.webp';
}

String iconForPaymentMethod({
  required String methodId,
}) {
  final iconApi = sNetwork.options.iconApi!.replaceAll('icons', 'resources/content');

  return '$iconApi/$methodId.webp';
}
