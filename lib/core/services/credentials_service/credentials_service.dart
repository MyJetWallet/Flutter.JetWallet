import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/rsa_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/current_platform.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';

import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/auth_api/models/login/authentication_response_model.dart';
import 'package:simple_networking/modules/auth_api/models/login_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/register_request_model.dart';
part 'credentials_service.g.dart';

enum AuthOperation { login, register }

/// Used only for [Register] and [Login] flow
/// Service for storing data during registration or authorization.

@lazySingleton
class CredentialsService = _CredentialsServiceBase with _$CredentialsService;

abstract class _CredentialsServiceBase with Store {
  @observable
  String email = '';

  @action
  void updateAndValidateEmail(String value) {
    email = value;

    validateEmail();
  }

  @observable
  String password = '';

  @action
  void updateAndValidatePassword(String value) {
    password = value;

    validatePassword();
  }

  @observable
  String referralCode = '';
  @action
  String setReferralCode(String value) => referralCode = value;

  @observable
  bool emailValid = false;

  @action
  void validateEmail() {
    isEmailValid(email) ? emailValid = true : emailValid = false;
  }

  @observable
  bool passwordValid = false;

  @action
  void validatePassword() {
    isPasswordValid(password) ? passwordValid = true : passwordValid = false;
  }

  @observable
  bool policyChecked = false;
  @action
  bool setPolicyChecked() => policyChecked = !policyChecked;

  @observable
  bool mailingChecked = false;
  @action
  bool setMailingChecked(bool value) => mailingChecked = value;

  @computed
  bool get emailIsNotEmptyAndPolicyChecked {
    return email.isNotEmpty && policyChecked;
  }

  @computed
  bool get readyToRegister {
    return emailValid && passwordValid;
  }

  @computed
  bool get readyToLogin {
    return emailValid && isPasswordLengthValid(password);
  }

  final storageService = getIt.get<LocalStorageService>();

  Future<void> authenticate({
    required AuthOperation operation,
    required Function(String) showError,
  }) async {
    final rsaService = getIt.get<RsaService>();

    try {
      rsaService.init();
      await rsaService.savePrivateKey(storageService);
      final publicKey = rsaService.publicKey;

      final authService =
          getIt.get<SNetwork>().simpleNetworking.getAuthModule();

      if (operation == AuthOperation.login) {
        final loginRequestModel = LoginRequestModel(
          publicKey: publicKey,
          email: email,
          password: password,
          platform: currentPlatform,
          deviceUid: getIt.get<DeviceInfo>().deviceUid,
          lang: intl.localeName,
        );

        final loginRequest = await authService.postLogin(loginRequestModel);

        loginRequest.pick(
          onData: (data) async {
            await successAuth(data);
          },
          onError: (error) {
            showError(error.cause);
          },
        );
      } else {
        final registerRequestModel = RegisterRequestModel(
          publicKey: publicKey,
          email: email,
          password: password,
          platformType: platformType,
          platform: currentPlatform,
          deviceUid: getIt.get<DeviceInfo>().deviceUid,
          referralCode: referralCode,
          marketingEmailsAllowed: mailingChecked,
          lang: intl.localeName,
        );

        final registerRequest =
            await authService.postRegister(registerRequestModel);

        registerRequest.pick(
          onData: (data) async {
            await successAuth(data);

            getIt.get<AppStore>().updateResendButton();
          },
          onError: (error) {
            if (error.cause.contains('50') || error.cause.contains('40')) {
              showError(intl.something_went_wrong_try_again);
            } else {
              showError(error.cause);
            }
          },
        );
      }
    } catch (e) {
      showError(intl.something_went_wrong_try_again);
    }
  }

  @action
  Future<void> successAuth(AuthenticationResponseModel authModel) async {
    await storageService.setString(
      refreshTokenKey,
      authModel.refreshToken,
    );
    await storageService.setString(userEmailKey, email);

    getIt.get<AppStore>().updateAuthState(
          token: authModel.token,
          refreshToken: authModel.refreshToken,
          email: email,
        );

    getIt.get<AppStore>().setAuthStatus(const AuthorizationUnion.authorized());

    /// Recreating a dio object with a token
    await getIt.get<SNetwork>().init(getIt<AppStore>().sessionID);

    getIt.get<StartupService>().successfullAuthentication();
  }

  @action
  void checkPolicy() {
    //_logger.log(notifier, 'checkPolicy');
    policyChecked = !policyChecked;
  }

  @action
  void checkMailing() {
    //_logger.log(notifier, 'checkMailing');
    mailingChecked = !mailingChecked;
  }
}
