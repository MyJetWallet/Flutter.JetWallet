import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/server_time/server_time_response_model.dart';
import '../authentication_service.dart';

Future<ServerTimeResponseModel> serverTimeService(
  Dio dio,
  String localName,
) async {
  final logger = AuthenticationService.logger;
  const message = 'serverTimeService';

  try {
    final response = await dio.get(
      '$authApi/common/server-time',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localName,);

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
