import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/phone_number/phone_number_response_model.dart';
import '../phone_verification_service.dart';

Future<PhoneNumberResponseModel> phoneNumberService(
  Dio dio,
  String localeName,
) async {
  final logger = PhoneVerificationService.logger;
  const message = 'phonenNumberService';

  try {
    final response = await dio.get(
      '$validationApi/phone-setup/get-number',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<String>(responseData, localeName);

      return PhoneNumberResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
