import 'package:dio/dio.dart';

import '../model/authenticate/authentication_model.dart';
import '../model/authenticate/login_request_model.dart';
import '../model/authenticate/register_request_model.dart';
import '../model/logout/logout_request_model.dart';
import '../model/refresh/auth_refresh_request_model.dart';
import '../model/refresh/auth_refresh_response_model.dart';
import 'services/login_service.dart';
import 'services/logout_service.dart';
import 'services/refresh_service.dart';
import 'services/register_service.dart';

class AuthenticationService {
  AuthenticationService(this.dio);

  final Dio dio;

  Future<AuthenticationModel> register(RegisterRequestModel model) {
    return registerService(dio, model);
  }

  Future<AuthenticationModel> login(LoginRequestModel model) {
    return loginService(dio, model);
  }

  Future<AuthRefreshResponseModel> refresh(AuthRefreshRequestModel model) {
    return refreshService(dio, model);
  }

  Future<void> logout(LogoutRequestModel model) {
    return logoutService(dio, model);
  }
}
