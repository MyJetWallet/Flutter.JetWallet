import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/forgot_password/forgot_password_request_model.dart';
import '../authentication_service.dart';

Future<void> forgotPasswordService(
  Dio dio,
  ForgotPasswordRequestModel model,
) async {
  final logger = AuthenticationService.logger;
  const message = 'forgotPasswordService';

  try {
    final response = await dio.post(
      '$authApi/trader/ForgotPasswordCode',
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
