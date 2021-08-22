import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../market_info/model/market_info_request_model.dart';
import '../../market_info/model/market_info_response_model.dart';
import '../../market_info/services/market_info_service.dart';
import '../model/asset_converter_map/asset_converter_map_model.dart';
import '../model/conversion_price_model/conversion_price_model.dart';
import 'services/asset_converter_map_service.dart';
import 'services/conversion_price_service.dart';

class WalletService {
  WalletService(this.dio);

  final Dio dio;

  static final logger = Logger('WalletService');

  Future<AssetConverterMapModel> assetConverterMap(String symbol) {
    return assetConverterMapService(dio, symbol);
  }

  Future<ConversionPriceModel> conversionPrice(
    String baseAssetSymbol,
    String quotedAssetSymbol,
  ) {
    return conversionPriceService(dio, baseAssetSymbol, quotedAssetSymbol);
  }

  Future<MarketInfoResponseModel> marketInfo(MarketInfoRequestModel model) {
    return marketInfoService(dio, model);
  }
}
