import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../model/check_pin/check_pin_request_model.dart';
import '../model/check_pin/check_pin_response_model.dart';
import '../pin_service.dart';

Future<CheckPinResponseModel> checkPinService(
  Dio dio,
  String pin,
  String localeName,
) async {
  final logger = PinService.logger;
  const message = 'CheckPinService';

  try {
    final model = CheckPinRequestModel(pin: pin);
    final response = await dio.post(
      '$authApi/pin/CheckPin',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<String>(responseData, localeName);

      return CheckPinResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
