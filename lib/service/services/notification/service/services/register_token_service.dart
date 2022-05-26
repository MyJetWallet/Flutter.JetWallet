import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/register_token_request_model.dart';
import '../notification_service.dart';

Future<void> registerTokenService(
  Dio dio,
  RegisterTokenRequestModel model,
  String localeName,
) async {
  final logger = NotificationService.logger;
  const message = 'registerTokenService';

  try {
    final response = await dio.post(
      '$walletApi/push/token',
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
