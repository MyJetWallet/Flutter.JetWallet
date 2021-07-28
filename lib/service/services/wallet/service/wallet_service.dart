import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/asset_converter_map/asset_converter_map_model.dart';
import '../model/market_info/market_info_request_model.dart';
import '../model/market_info/market_info_response_model.dart';
import 'services/asset_converter_map_service.dart';
import 'services/market_info_service.dart';

class WalletService {
  WalletService(this.dio);

  final Dio dio;

  static final logger = Logger('WalletService');

  Future<AssetConverterMapModel> assetConverterMap(String symbol) {
    return assetConverterMapService(dio, symbol);
  }

  Future<MarketInfoResponseModel> marketInfo(MarketInfoRequestModel model) {
    return marketInfoService(dio, model);
  }
}
