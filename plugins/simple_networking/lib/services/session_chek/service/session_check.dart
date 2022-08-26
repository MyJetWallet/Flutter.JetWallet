import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../authentication/service/authentication_service.dart';
import '../model/session_check_request_model.dart';
import '../model/session_check_response_model.dart';

Future<SessionCheckResponseModel> sessionCheckService(
  Dio dio,
  String localeName,
) async {
  final logger = AuthenticationService.logger;
  const message = 'sessionCheck';

  try {
    final response = await dio.post(
      '$authApi/session/Check',
      data: const SessionCheckRequestModel(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);
      return SessionCheckResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
