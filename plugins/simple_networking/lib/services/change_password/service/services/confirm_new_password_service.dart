import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/change_password_request_model.dart';
import '../change_password_service.dart';

Future<void> confirmNewPasswordService(
  Dio dio,
  ChangePasswordRequestModel model,
) async {
  final logger = ChangePasswordService.logger;
  const message = 'phoneVerificationRequestService';

  try {
    final response = await dio.post(
      '$authApi/trader/ChangePassword',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
