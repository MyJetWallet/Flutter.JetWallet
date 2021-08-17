import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/asset_converter_map/asset_converter_map_model.dart';
import '../model/conversion_price_model/conversion_price_model.dart';
import '../model/key_value/key_value_request_model.dart';
import '../model/market_info/market_info_request_model.dart';
import '../model/market_info/market_info_response_model.dart';
import '../model/news/news_request_model.dart';
import '../model/news/news_response_model.dart';
import 'services/asset_converter_map_service.dart';
import 'services/conversion_price_service.dart';
import 'services/get_key_service.dart';
import 'services/market_info_service.dart';
import 'services/news_service.dart';
import 'services/remove_key_service.dart';
import 'services/set_key_service.dart';

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

  Future<NewsResponseModel> news(NewsRequestModel model) {
    return newsService(dio, model);
  }

  Future<List<dynamic>> keyValues() {
    return keyValueService(dio);
  }

  Future<void> keyValueRemove(String key) {
    return keyValueRemoveService(dio, key);
  }

  Future<void> keyValueSet(KeyValueRequestModel model) {
    return keyValueSetService(dio, model);
  }
}
