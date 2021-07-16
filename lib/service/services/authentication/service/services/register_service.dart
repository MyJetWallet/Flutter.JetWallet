import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../model/authenticate/authentication_model.dart';
import '../../model/authenticate/register_request_model.dart';
import '../authentication_service.dart';
import '../helpers/handle_auth_response.dart';

Future<AuthenticationModel> registerService(
  Dio dio,
  RegisterRequestModel model,
) async {
  final logger = AuthenticationService.logger;
  const message = 'registerService';

  try {
    final response = await dio.post(
      '$tradingAuthApi/Trader/Register',
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
