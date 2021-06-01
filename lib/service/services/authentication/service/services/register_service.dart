import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../model/authenticate/authentication_model.dart';
import '../../model/authenticate/register_request_model.dart';
import '../helpers/handle_auth_response.dart';

Future<AuthenticationModel> registerService(
  Dio dio,
  RegisterRequestModel model,
) async {
  final response = await dio.post(
    '$tradingAuthBaseUrl/Trader/Register',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  return handleAuthResponse(responseData);
}
