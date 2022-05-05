import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/server_time/server_time_response_model.dart';
import '../authentication_service.dart';

Future<ServerTimeResponseModel> serverTimeService(
  Dio dio,
) async {
  final logger = AuthenticationService.logger;
  const message = 'serverTimeService';

  try {
    final response = await dio.get(
      '$authApi/common/server-time',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return ServerTimeResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
