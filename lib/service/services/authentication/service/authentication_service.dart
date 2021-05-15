import 'package:dio/dio.dart';

import '../model/authentication_model.dart';
import '../model/authentication_refresh_request_model.dart';
import '../model/authentication_refresh_response_model.dart';
import '../model/login_request_model.dart';
import '../model/register_request_model.dart';
import 'authentication_service_abstract.dart';
import 'services/login_service.dart';
import 'services/refresh_service.dart';
import 'services/register_service.dart';

class AuthenticationService implements AuthenticationServiceAbstract {
  AuthenticationService(this.dio);

  final Dio dio;

  @override
  Future<AuthenticationModel> register(RegisterRequestModel model) {
    return registerService(dio, model);
  }

  @override
  Future<AuthenticationModel> login(LoginRequestModel model) {
    return loginService(dio, model);
  }

  @override
  Future<AuthenticationRefreshResponseModel> refresh(
    AuthenticationRefreshRequestModel model,
  ) {
    return refreshService(dio, model);
  }
}
