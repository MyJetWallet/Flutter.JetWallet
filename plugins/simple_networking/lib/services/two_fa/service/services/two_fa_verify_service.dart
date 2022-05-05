import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/two_fa_verify/two_fa_verify_request_model.dart';
import '../two_fa_service.dart';

Future<void> twoFaVerifyService(
  Dio dio,
  TwoFaVerifyRequestModel model,
) async {
  final logger = TwoFaService.logger;
  const message = 'twoFaVerifyService';

  try {
    final response = await dio.post(
      '$validationApi/2fa/verify',
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
