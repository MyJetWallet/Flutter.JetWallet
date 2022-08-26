import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../model/reset_pin/reset_pin_request_model.dart';
import '../model/reset_pin/reset_pin_response_model.dart';
import '../pin_service.dart';

Future<ResetPinResponseModel> resetPinService(
  Dio dio,
  String localeName,
) async {
  final logger = PinService.logger;
  const message = 'resetPinService';

  try {
    const model = ResetPinRequestModel();
    final response = await dio.post(
      '$authApi/pin/ResetPin',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<String>(responseData, localeName);

      return ResetPinResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
