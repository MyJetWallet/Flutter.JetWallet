import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';

Future<Decimal?> getConversionPrice(ConversionPriceInput input) async {
  final response = await sNetwork.getWalletModule().getConversionPrice(
        input.baseAssetSymbol,
        input.quotedAssetSymbol,
      );

  response.pick(
    onData: (data) {
      return data.price;
    },
    onNoError: (data) {
      return data?.price;
    },
    onNoData: () {
      return null;
    },
    onError: (e) {
      return null;
    },
  );

  return null;
}
