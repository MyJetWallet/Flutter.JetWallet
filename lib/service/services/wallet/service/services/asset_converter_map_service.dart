import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/asset_converter_map_model.dart';

Future<AssetConverterMapModel> assetConverterMapService(
  Dio dio,
  String symbol,
) async {
  final response = await dio.get(
    '$walletApiBaseUrl/wallet/base-currency-converter-map/$symbol',
  );

  final responseData = response.data as Map<String, dynamic>;

  final data = handleFullResponse<Map>(responseData);

  return AssetConverterMapModel.fromJson(data);
}
