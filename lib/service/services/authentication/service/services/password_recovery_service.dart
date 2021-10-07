import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/password_recovery/password_recovery_request_model.dart';
import '../authentication_service.dart';

Future<void> recoverPasswordService(
  Dio dio,
  PasswordRecoveryRequestModel model,
) async {
  final logger = AuthenticationService.logger;
  const message = 'passwordRecoveryService';

  try {
    final response = await dio.post(
      '$authApi/trader/PasswordRecovery',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
