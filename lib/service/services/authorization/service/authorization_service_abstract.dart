import '../model/authorization_refresh_request_model.dart';
import '../model/authorization_request_model.dart';
import '../model/authorization_response_model.dart';

abstract class AuthorizationServiceAbstract {
  Future<void> logout();

  Future<AuthorizationResponseModel> authorize(
    AuthorizationRequestModel model,
  );

  Future<AuthorizationResponseModel> refresh(
    AuthorizationRefreshRequestModel model,
  );
}
