import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../model/authenticate/authentication_model.dart';
import '../../model/authenticate/login_request_model.dart';
import '../helpers/handle_auth_response.dart';

Future<AuthenticationModel> loginService(
  Dio dio,
  LoginRequestModel model,
) async {
  final response = await dio.post(
    '$tradingAuthBaseUrl/Trader/Authenticate',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  return handleAuthResponse(responseData);
}
