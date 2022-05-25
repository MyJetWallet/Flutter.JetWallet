import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/verify_withdrawal_verification_code_request_model.dart';
import '../validation_service.dart';

Future<void> verifyTransferVerificationCodeService(
  Dio dio,
  VerifyWithdrawalVerificationCodeRequestModel model,
  String localeName,
) async {
  final logger = ValidationService.logger;
  const message = 'verifyTransferVerificationCodeService';

  try {
    final response = await dio.post(
      '$validationApi/transfer-verification/verify-code',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData, localeName);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
