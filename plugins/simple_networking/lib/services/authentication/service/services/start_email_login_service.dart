import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';

import '../../model/start_email_login/start_email_login_request_model.dart';
import '../../model/start_email_login/start_email_login_response_model.dart';
import '../authentication_service.dart';

Future<StartEmailLoginResponseModel> startEmailLoginService(
    Dio dio,
    StartEmailLoginRequestModel model,
    String localName,
    ) async {
  final logger = AuthenticationService.logger;
  const message = 'startEmailLoginService';

  try {
    final response = await dio.post(
      '$authApi/signin/StartEmailLogin',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(
        responseData,
        localName,
      );

      return StartEmailLoginResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
