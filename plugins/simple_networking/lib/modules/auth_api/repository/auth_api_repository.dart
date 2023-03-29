import 'package:data_channel/data_channel.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/auth_api/data_sources/auth_api_data_sources.dart';
import 'package:simple_networking/modules/auth_api/models/change_password/change_password_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/change_pin/change_pin_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/check_pin/check_pin_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/confirm_email_login/confirm_email_login_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/confirm_email_login/confirm_email_login_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/country/country_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/forgot_password/forgot_password_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/install_model.dart';
import 'package:simple_networking/modules/auth_api/models/login/authentication_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/login_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/logout/logout_request_moder.dart';
import 'package:simple_networking/modules/auth_api/models/password_recovery_request_mode.dart';
import 'package:simple_networking/modules/auth_api/models/refresh/auth_refresh_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/refresh/auth_refresh_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/register_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/reset_pin/reset_pin_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/server_time/server_time_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/session_chek/session_check_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/setup_pin/setup_pin_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/start_email_login/start_email_login_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/start_email_login/start_email_login_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/validate_referral_code/validate_referral_code_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc_profile/apply_user_data_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc_profile/country_list_response_model.dart';

class AuthApiRepository {
  AuthApiRepository(this._apiClient) {
    _authApiDataSource = AuthApiDataSources(_apiClient);
  }

  final ApiClient _apiClient;
  late final AuthApiDataSources _authApiDataSource;

  Future<DC<ServerRejectException, String>> postTestRequest() async {
    return _authApiDataSource.postTestRequest();
  }

  Future<DC<ServerRejectException, bool>> postForgotPassword(
    ForgotPasswordRequestModel model,
  ) async {
    return _authApiDataSource.postForgotPasswordRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, AuthenticationResponseModel>> postLogin(
    LoginRequestModel model,
  ) async {
    return _authApiDataSource.postLoginRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, bool>> postLogout(
    LogoutRequestModel model,
  ) async {
    return _authApiDataSource.postLogoutRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, bool>> postRecoverPassword(
    PasswordRecoveryRequestModel model,
  ) async {
    return _authApiDataSource.postRecoverPasswordRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, AuthRefreshResponseModel>> postRefresh(
    AuthRefreshRequestModel model,
  ) async {
    return _authApiDataSource.postRefreshRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, AuthenticationResponseModel>> postRegister(
    RegisterRequestModel model,
  ) async {
    return _authApiDataSource.postRegisterRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, ServerTimeResponseModel>>
      getServerTime() async {
    return _authApiDataSource.getServerTimeRequest();
  }

  Future<DC<ServerRejectException, bool>> poshConfirmNewPassword(
    ChangePasswordRequestModel model,
  ) async {
    return _authApiDataSource.postConfirmNewPasswordRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, bool>> postValidateReferralCode(
    ValidateReferralCodeRequestModel model,
  ) async {
    return _authApiDataSource.postValidateReferralCodeRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postApplyUsedData(
    ApplyUseDataRequestModel model,
  ) async {
    return _authApiDataSource.postApplyUsedDataRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, CountryListResponseModel>>
      getCountryList() async {
    return _authApiDataSource.getCountryListRequest();
  }

  Future<DC<ServerRejectException, ChangePinResponseModel>> postChangePin(
    String oldPin,
    String newPin,
  ) async {
    return _authApiDataSource.postChangePinRequest(
      oldPin,
      newPin,
    );
  }

  Future<DC<ServerRejectException, CheckPinResponseModel>> postCheckPin(
    String pin,
  ) async {
    return _authApiDataSource.postCheckPinRequest(
      pin,
    );
  }

  Future<DC<ServerRejectException, SetupPinResponseModel>> postSetupPin(
    String pin,
  ) async {
    return _authApiDataSource.postSetupPinRequest(
      pin,
    );
  }

  Future<DC<ServerRejectException, ResetPinResponseModel>>
      postResetPin() async {
    return _authApiDataSource.postResetPinRequest();
  }

  Future<DC<ServerRejectException, SessionCheckResponseModel>>
      postSessionCheck() async {
    return _authApiDataSource.postSessionCheckRequest();
  }

  Future<DC<ServerRejectException, StartEmailLoginResponseModel>>
      postStartEmailLogin(
    StartEmailLoginRequestModel model,
  ) async {
    return _authApiDataSource.postStartEmailLoginRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, ConfirmEmailLoginResponseModel>>
      postConfirmEmailLogin(
    ConfirmEmailLoginRequestModel model,
  ) async {
    return _authApiDataSource.postConfirmEmailLoginRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, CountryResponseModel>>
      getUserCountry() async {
    return _authApiDataSource.getUserCountryRequest();
  }

  Future<DC<ServerRejectException, void>> postInstall(
      InstallModel model) async {
    return _authApiDataSource.postInstallRequest(model);
  }
}
