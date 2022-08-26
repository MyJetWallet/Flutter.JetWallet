import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/services/authentication/model/start_email_login/start_email_login_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../shared/helpers/current_platform.dart';
import '../../../../shared/providers/apps_flyer_service_pod.dart';
import '../../../../shared/providers/device_info_pod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import 'single_sing_in_state.dart';
import 'single_sing_in_union.dart';

class SingleSingInNotifier extends StateNotifier<SingleSingInState> {
  SingleSingInNotifier(
    this.read,
  ) : super(const SingleSingInState());

  final Reader read;
  static final _logger = Logger('SingleSingInNotifier');

  Future<void> singleSingIn() async {
    _logger.log(notifier, 'singleSingIn');
    final deviceInfoModel = read(deviceInfoPod);
    final appsFlyerService = read(appsFlyerServicePod);
    final intl = read(intlPod);
    final appsFlyerID = await appsFlyerService.appsflyerSdk.getAppsFlyerUID();
    final authService = read(authServicePod);
    final authInfoN = read(authInfoNotipod.notifier);
    final credentials = read(credentialsNotipod);
    try {
      state = state.copyWith(union: const Loading());
      final model = StartEmailLoginRequestModel(
        email: credentials.email,
        platform: currentPlatform,
        deviceUid: deviceInfoModel.deviceUid,
        lang: intl.localeName,
        application: currentAppPlatform,
        appsflyerId: appsFlyerID ?? '',
      );
      final response =
          await authService.startEmailLogin(model, intl.localeName);
      authInfoN.updateEmail(credentials.email);
      authInfoN.updateVerificationToken(response.verificationToken);

      if (response.rejectDetail == null) {
        state = state.copyWith(union: const Success());
      } else {
        state = state.copyWith(
          union: ErrorSrting(response.rejectDetail.toString()),
        );
      }
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'singleSingIn', error.cause);
      state = state.copyWith(union: Error(error.cause));
    } catch (e) {
      _logger.log(stateFlow, 'singleSingIn', e);
      state = state.copyWith(union: Error(e));
    }
  }
}
