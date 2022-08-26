import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../model/change_pin/change_pin_request_model.dart';
import '../model/change_pin/change_pin_response_model.dart';
import '../pin_service.dart';

Future<ChangePinResponseModel> changePinService(
  Dio dio, String localeName,
  String oldPin,
  String newPin,

) async {
  final logger = PinService.logger;
  const message = 'ChangePinService';

  try {
    final response = await dio.post(
      '$authApi/pin/ChangePin',
      data: ChangePinRequestModel(oldPin: oldPin, newPin: newPin),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;
      final data = handleFullResponse<String>(responseData, localeName);
      return ChangePinResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
