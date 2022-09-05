import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/auth/single_sign_in/models/single_sing_in_union.dart';
import 'package:jetwallet/utils/helpers/current_platform.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/auth_api/models/start_email_login/start_email_login_request_model.dart';
part 'single_sing_in_store.g.dart';

class SingleSingInStore extends _SingleSingInStoreBase
    with _$SingleSingInStore {
  SingleSingInStore(String? email) : super(email);

  static _SingleSingInStoreBase of(BuildContext context) =>
      Provider.of<SingleSingInStore>(context, listen: false);
}

abstract class _SingleSingInStoreBase with Store {
  _SingleSingInStoreBase(this.email) {
    emailController = TextEditingController(text: email);
  }

  final String? email;

  static final _logger = Logger('SingleSingInStore');

  late TextEditingController emailController;

  @observable
  SingleSingInStateUnion union = const SingleSingInStateUnion.input();

  @observable
  bool isEmailError = false;
  @action
  bool setIsEmailError(bool value) => isEmailError = value;

  @action
  Future<void> singleSingIn() async {
    _logger.log(notifier, 'singleSingIn');

    final deviceInfoModel = sDeviceInfo.model;
    final appsFlyerService = getIt.get<AppsFlyerService>();

    final appsFlyerID = await appsFlyerService.appsflyerSdk.getAppsFlyerUID();
    final authInfoN = getIt.get<AppStore>();

    final credentials = getIt.get<CredentialsService>();

    try {
      union = const SingleSingInStateUnion.loading();

      final model = StartEmailLoginRequestModel(
        email: credentials.email,
        platform: currentAppPlatform,
        deviceUid: deviceInfoModel.deviceUid,
        lang: intl.localeName,
        application: currentAppPlatform,
        appsflyerId: appsFlyerID ?? '',
      );

      print(model);

      final response =
          await sNetwork.getAuthModule().postStartEmailLogin(model);

      response.pick(
        onData: (data) {
          authInfoN.updateAuthState(email: credentials.email);
          authInfoN.updateVerificationToken(data.verificationToken);

          print(data);

          data.rejectDetail == null
              ? union = const SingleSingInStateUnion.success()
              : union = SingleSingInStateUnion.errorString(
                  data.rejectDetail.toString(),
                );
        },
        onError: (error) {
          print(error.cause);

          union = SingleSingInStateUnion.errorString(
            error.cause,
          );
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'singleSingIn', error.cause);

      union = SingleSingInStateUnion.error(error.cause);
    } catch (e) {
      _logger.log(stateFlow, 'singleSingIn', e);

      union = SingleSingInStateUnion.error(e);
    }
  }

  @action
  void dispose() {
    emailController.dispose();
  }
}
