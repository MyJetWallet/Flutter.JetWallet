import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/authenticate/authentication_response_model.dart';
import '../../model/authenticate/register_request_model.dart';
import '../authentication_service.dart';

Future<AuthenticationResponseModel> registerService(
  Dio dio,
  RegisterRequestModel model,
) async {
  final logger = AuthenticationService.logger;
  const message = 'registerService';

  try {
    final response = await dio.post(
      '$authApi/trader/Register',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return AuthenticationResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
