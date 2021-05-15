import '../model/authentication_model.dart';
import '../model/authentication_refresh_request_model.dart';
import '../model/authentication_refresh_response_model.dart';
import '../model/login_request_model.dart';
import '../model/register_request_model.dart';

abstract class AuthenticationServiceAbstract {
  Future<AuthenticationModel> register(RegisterRequestModel model);

  Future<AuthenticationModel> login(LoginRequestModel model);

  Future<AuthenticationRefreshResponseModel> refresh(
    AuthenticationRefreshRequestModel model,
  );
}
