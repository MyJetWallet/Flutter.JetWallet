import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/email_verification/email_verification_request_model.dart';
import '../../model/email_verification/email_verification_response_model.dart';

Future<EmailVerificationResponseModel> emailVerificationService(
  Dio dio,
  EmailVerificationRequestModel model,
) async {
  final response = await dio.post(
    '$validationApi/email-verification/request',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final data = handleFullResponse<String>(responseData);

  return EmailVerificationResponseModel.fromJson(data);
}
