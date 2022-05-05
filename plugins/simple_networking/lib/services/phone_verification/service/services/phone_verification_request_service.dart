import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/phone_verification/phone_verification_request_model.dart';
import '../phone_verification_service.dart';

Future<void> phoneVerificationRequestService(
  Dio dio,
  PhoneVerificationRequestModel model,
) async {
  final logger = PhoneVerificationService.logger;
  const message = 'phoneVerificationRequestService';

  try {
    final response = await dio.post(
      '$validationApi/phone-setup/request',
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
