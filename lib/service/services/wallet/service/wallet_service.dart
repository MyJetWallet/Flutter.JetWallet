import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/asset_converter_map_model.dart';
import 'services/asset_converter_map_service.dart';

class WalletService {
  WalletService(this.dio);

  final Dio dio;

  static final logger = Logger('WalletService');

  Future<AssetConverterMapModel> assetConverterMap(String symbol) {
    return assetConverterMapService(dio, symbol);
  }
}
