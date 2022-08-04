import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';

import '../../model/confirm_email_login/confirm_email_login_request_model.dart';
import '../../model/confirm_email_login/confirm_email_login_response_model.dart';
import '../authentication_service.dart';

Future<ConfirmEmailLoginResponseModel> confirmEmailLoginService(
    Dio dio,
    ConfirmEmailLoginRequestModel model,
    String localName,
    ) async {
  final logger = AuthenticationService.logger;
  const message = 'confirmEmailLoginService';

  try {
    final response = await dio.post(
      '$authApi/signin/ConfirmEmailLogin',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(
        responseData,
        localName,
      );

      return ConfirmEmailLoginResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
