import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/password_recovery/password_recovery_request_model.dart';
import '../authentication_service.dart';

Future<void> recoverPasswordService(
  Dio dio,
  PasswordRecoveryRequestModel model,
  String localeName,
) async {
  final logger = AuthenticationService.logger;
  const message = 'passwordRecoveryService';

  try {
    final response = await dio.post(
      '$authApi/trader/PasswordRecoveryCode',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData, localeName);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
