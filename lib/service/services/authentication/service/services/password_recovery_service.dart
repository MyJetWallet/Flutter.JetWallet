import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../model/password_recovery/password_recovery_request_model.dart';
import '../authentication_service.dart';
import '../helpers/handle_auth_response.dart';

Future<void> recoverPasswordService(
  Dio dio,
  PasswordRecoveryRequestModel model,
) async {
  final logger = AuthenticationService.logger;
  const message = 'passwordRecoveryService';

  try {
    final response = await dio.post(
      '$tradingAuthApi/Trader/PasswordRecovery',
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
