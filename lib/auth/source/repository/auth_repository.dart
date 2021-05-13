import '../../model/auth_model.dart';
import '../../model/authentication/login_request_model.dart';
import '../../model/authentication/register_request_model.dart';
import '../../model/authorization/authorization_request_model.dart';
import '../../model/authorization/authorization_response_model.dart';
import 'repositories/authorization_repository.dart';
import 'repositories/login_repository.dart';
import 'repositories/logout_repository.dart';
import 'repositories/register_repository.dart';

class AuthRepository {
  static Future<AuthModel> register(RegisterRequestModel model) {
    return registerRepository(model);
  }

  static Future<AuthModel> login(LoginRequestModel model) {
    return loginRepository(model);
  }

  static Future<void> logout() {
    return logoutRepository();
  }

  static Future<AuthorizationResponseModel> authorize(
    AuthorizationRequestModel model,
  ) {
    return authorizationRepository(model);
  }
}
