import 'package:dio/dio.dart';

import '../model/asset_converter_map_model.dart';
import 'services/asset_converter_map_service.dart';

class WalletService {
  WalletService(this.dio);

  final Dio dio;

  Future<AssetConverterMapModel> assetConverterMap(String symbol) {
    return assetConverterMapService(dio, symbol);
  }
}
