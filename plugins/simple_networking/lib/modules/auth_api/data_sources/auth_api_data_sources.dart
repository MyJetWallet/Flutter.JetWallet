import 'package:data_channel/data_channel.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/helpers/handle_api_responses.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/auth_api/models/change_password/change_password_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/change_pin/change_pin_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/change_pin/change_pin_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/check_pin/check_pin_request_model.dart';
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
import 'package:simple_networking/modules/auth_api/models/reset_pin/reset_pin_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/reset_pin/reset_pin_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/server_time/server_time_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/session_chek/session_check_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/setup_pin/setup_pin_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/setup_pin/setup_pin_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/start_email_login/start_email_login_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/start_email_login/start_email_login_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/validate_referral_code/validate_referral_code_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc_profile/apply_user_data_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc_profile/country_list_response_model.dart';

class AuthApiDataSources {
  final ApiClient _apiClient;

  AuthApiDataSources(this._apiClient);

  Future<DC<ServerRejectException, String>> postTestRequest() async {
    try {
      /*final response = await _apiClient.post(
        '/trader/ForgotPasswordCode',
        '',
      );

      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData);*/

      return DC.data('SUCCESS');
    } catch (e) {
      rethrow;
    }
  }

  Future<DC<ServerRejectException, bool>> postForgotPasswordRequest(
    ForgotPasswordRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/trader/ForgotPasswordCode',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DC<ServerRejectException, AuthenticationResponseModel>> postLoginRequest(
    LoginRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/trader/AuthenticateW2',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(AuthenticationResponseModel.fromJson(data));
      } on ServerRejectException catch (error) {
        return DC.error(error);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DC<ServerRejectException, bool>> postLogoutRequest(
    LogoutRequestModel model,
  ) async {
    try {
      await _apiClient.post(
        '${_apiClient.options.authApi}/trader/Logout',
        data: model.toJson(),
      );

      return DC.data(true);
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postRecoverPasswordRequest(
    PasswordRecoveryRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/trader/PasswordRecoveryCode',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, AuthRefreshResponseModel>> postRefreshRequest(
    AuthRefreshRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/trader/RefreshToken',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(AuthRefreshResponseModel.fromJson(data));
      } on ServerRejectException catch (error) {
        return DC.error(error);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DC<ServerRejectException, AuthenticationResponseModel>> postRegisterRequest(
    RegisterRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/trader/Register',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(AuthenticationResponseModel.fromJson(data));
      } on ServerRejectException catch (error) {
        return DC.error(error);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DC<ServerRejectException, ServerTimeResponseModel>> getServerTimeRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.authApi}/common/server-time',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(ServerTimeResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postConfirmNewPasswordRequest(
    ChangePasswordRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/trader/ChangePassword',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postValidateReferralCodeRequest(
    ValidateReferralCodeRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/trader/VerifyReferralCode',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postApplyUsedDataRequest(
    ApplyUseDataRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/kycprofile/Apply',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CountryListResponseModel>> getCountryListRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.authApi}/kycprofile/CountryList',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(CountryListResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, ChangePinResponseModel>> postChangePinRequest(
    String oldPin,
    String newPin,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/pin/ChangePin',
        data: ChangePinRequestModel(oldPin: oldPin, newPin: newPin),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<String>(responseData);

        return DC.data(ChangePinResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CheckPinResponseModel>> postCheckPinRequest(
    String pin,
  ) async {
    try {
      final model = CheckPinRequestModel(pin: pin);

      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/pin/CheckPin',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<String>(responseData);

        return DC.data(CheckPinResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SetupPinResponseModel>> postSetupPinRequest(
    String pin,
  ) async {
    try {
      final model = SetupPinRequestModel(pin: pin);

      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/pin/SetupPin',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<String>(responseData);

        return DC.data(SetupPinResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, ResetPinResponseModel>> postResetPinRequest() async {
    try {
      const model = ResetPinRequestModel();
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/pin/ResetPin',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<String>(responseData);

        return DC.data(ResetPinResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, SessionCheckResponseModel>> postSessionCheckRequest() async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/session/Check',
        data: {},
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(SessionCheckResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, StartEmailLoginResponseModel>> postStartEmailLoginRequest(
    StartEmailLoginRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/signin/StartEmailLogin',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(StartEmailLoginResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, ConfirmEmailLoginResponseModel>> postConfirmEmailLoginRequest(
    ConfirmEmailLoginRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/signin/ConfirmEmailLogin',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(ConfirmEmailLoginResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, CountryResponseModel>> getUserCountryRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.authApi}/common/ip-country',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<Map>(responseData);

        return DC.data(CountryResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postInstallRequest(
    InstallModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.authApi}/common/install',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final _ = handleFullResponse<Map>(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }
}
