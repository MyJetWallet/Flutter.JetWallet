import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../shared/api_urls.dart';
import '../../model/server_info/server_info_response_model.dart';
import '../authentication_service.dart';

Future<ServerInfoResponseModel> serverInfoService(
    Dio dio,
    ) async {
  final logger = AuthenticationService.logger;
  const message = 'serverInfoService';

  try {
    final response = await dio.get(
      '$tradingAuthApi/Common/ServerInfo',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      return ServerInfoResponseModel.fromJson(responseData);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}