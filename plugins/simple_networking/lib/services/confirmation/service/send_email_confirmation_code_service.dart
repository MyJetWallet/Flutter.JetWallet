import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../authentication/service/authentication_service.dart';
import '../model/send_email_confirmation_request.dart';
import '../model/send_email_confirmation_response.dart';

Future<SendEmailConfirmationResponse> sendEmailConfirmationCodeService(
  Dio dio,
  SendEmailConfirmationRequest model,
  String localeName,
) async {
  final logger = AuthenticationService.logger;
  const message = 'emailConfirmationService';

  try {
    final response = await dio.post(
      '$validationApi/verification/request',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return SendEmailConfirmationResponse.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
