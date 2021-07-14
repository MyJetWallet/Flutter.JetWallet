import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/authenticate/authentication_model.dart';
import '../model/authenticate/login_request_model.dart';
import '../model/authenticate/register_request_model.dart';
import '../model/forgot_password/forgot_password_request_model.dart';
import '../model/logout/logout_request_model.dart';
import '../model/password_recovery/password_recovery_request_model.dart';
import '../model/refresh/auth_refresh_request_model.dart';
import '../model/refresh/auth_refresh_response_model.dart';
import '../model/server_info/server_info_response_model.dart';
import 'services/forgot_password_service.dart';
import 'services/login_service.dart';
import 'services/logout_service.dart';
import 'services/password_recovery_service.dart';
import 'services/refresh_service.dart';
import 'services/register_service.dart';
import 'services/server_info_service.dart';

class AuthenticationService {
  AuthenticationService(this.dio);

  final Dio dio;

  static final logger = Logger('AuthenticationService');

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

  Future<void> forgotPassword(ForgotPasswordRequestModel model) {
    return forgotPasswordService(dio, model);
  }

  Future<void> recoverPassword(PasswordRecoveryRequestModel model) {
    return recoverPasswordService(dio, model);
  }

  Future<ServerInfoResponseModel> serverInfo() {
    return serverInfoService(dio);
  }
}
