import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../shared/api_urls.dart';
import '../../model/forgot_password/forgot_password_request_model.dart';
import '../authentication_service.dart';
import '../helpers/handle_auth_response.dart';

Future<void> forgotPasswordService(
  Dio dio,
  ForgotPasswordRequestModel model,
) async {
  final logger = AuthenticationService.logger;
  const message = 'forgotPasswordService';

  try {
    final response = await dio.post(
      '$tradingAuthBaseUrl/Trader/ForgotPassword',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleAuthResult(responseData);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
