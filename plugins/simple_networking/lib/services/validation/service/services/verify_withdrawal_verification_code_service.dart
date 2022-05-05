import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/verify_withdrawal_verification_code_request_model.dart';
import '../validation_service.dart';

Future<void> verifyWithdrawalVerificationCodeService(
  Dio dio,
  VerifyWithdrawalVerificationCodeRequestModel model,
) async {
  final logger = ValidationService.logger;
  const message = 'verifyWithdrawalVerificationCodeService';

  try {
    final response = await dio.post(
      '$validationApi/withdrawal-verification/verify-code',
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
