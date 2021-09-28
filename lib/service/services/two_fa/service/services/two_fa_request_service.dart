import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/two_fa_verification/two_fa_verification_request_model.dart';
import '../two_fa_service.dart';

Future<void> twoFaRequestService(
  Dio dio,
  TwoFaVerificationRequestModel model,
) async {
  final logger = TwoFaService.logger;
  const message = 'twoFaRequestService';

  try {
    final response = await dio.post(
      '$validationApi/2fa/request-verification',
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
