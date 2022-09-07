import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';

Future<Decimal?> getConversionPrice(ConversionPriceInput input) async {
  final response = await sNetwork.getWalletModule().getConversionPrice(
        input.baseAssetSymbol,
        input.quotedAssetSymbol,
      );

  return response.data?.price;
}
