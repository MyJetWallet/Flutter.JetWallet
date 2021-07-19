import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../model/authenticate/authentication_model.dart';
import '../../model/authenticate/login_request_model.dart';
import '../authentication_service.dart';
import '../helpers/handle_auth_response.dart';

Future<AuthenticationModel> loginService(
  Dio dio,
  LoginRequestModel model,
) async {
  final logger = AuthenticationService.logger;
  const message = 'loginService';

  try {
    final response = await dio.post(
      '$tradingAuthApi/Trader/Authenticate',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      return handleAuthResponse(responseData);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
