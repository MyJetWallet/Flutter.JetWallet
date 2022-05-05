import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/register_token_request_model.dart';
import '../notification_service.dart';

Future<void> registerTokenService(
  Dio dio,
  RegisterTokenRequestModel model,
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
