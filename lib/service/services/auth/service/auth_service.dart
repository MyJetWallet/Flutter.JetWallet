import '../model/authentication/auth_model.dart';
import '../model/authentication/login_request_model.dart';
import '../model/authentication/register_request_model.dart';
import '../model/authorization/authorization_request_model.dart';
import '../model/authorization/authorization_response_model.dart';

import 'services/authorization_service.dart';
import 'services/login_service.dart';
import 'services/logout_service.dart';
import 'services/regiser_service.dart';

class AuthService {
  static Future<AuthModel> register(RegisterRequestModel model) {
    return registerService(model);
  }

  static Future<AuthModel> login(LoginRequestModel model) {
    return loginService(model);
  }

  static Future<void> logout() {
    return logoutService();
  }

  static Future<AuthorizationResponseModel> authorize(
    AuthorizationRequestModel model,
  ) {
    return authorizationService(model);
  }
}
