import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../model/setup_pin/setup_pin_request_model.dart';
import '../model/setup_pin/setup_pin_response_model.dart';
import '../pin_service.dart';

Future<SetupPinResponseModel> setupPinService(
  Dio dio,
  String pin,
  String localeName,
) async {
  final logger = PinService.logger;
  const message = 'setupPinService';

  try {
    final response = await dio.post('$authApi/pin/SetupPin',
        data: SetupPinRequestModel(pin: pin));

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<String>(responseData, localeName);

      return SetupPinResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
