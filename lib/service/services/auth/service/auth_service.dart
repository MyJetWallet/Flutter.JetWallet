import '../model/authentication/auth_model.dart';
import '../model/authentication/login_request_model.dart';
import '../model/authentication/register_request_model.dart';
import '../model/authorization/authorization_request_model.dart';
import '../model/authorization/authorization_response_model.dart';

import 'auth_service_abstract.dart';
import 'services/authorization_service.dart';
import 'services/login_service.dart';
import 'services/logout_service.dart';
import 'services/regiser_service.dart';

class AuthService implements AuthServiceAbstract {
  @override
  Future<AuthModel> register(RegisterRequestModel model) {
    return registerService(model);
  }

  @override
  Future<AuthModel> login(LoginRequestModel model) {
    return loginService(model);
  }

  @override
  Future<void> logout() {
    return logoutService();
  }

  @override
  Future<AuthorizationResponseModel> authorize(
    AuthorizationRequestModel model,
  ) {
    return authorizationService(model);
  }
}
