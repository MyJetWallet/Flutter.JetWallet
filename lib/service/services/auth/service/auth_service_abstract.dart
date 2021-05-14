import '../model/authentication/auth_model.dart';
import '../model/authentication/login_request_model.dart';
import '../model/authentication/register_request_model.dart';
import '../model/authorization/authorization_request_model.dart';
import '../model/authorization/authorization_response_model.dart';

abstract class AuthServiceAbstract {
  Future<AuthModel> register(RegisterRequestModel model);

  Future<AuthModel> login(LoginRequestModel model);

  Future<void> logout();

  Future<AuthorizationResponseModel> authorize(
    AuthorizationRequestModel model,
  );
}
