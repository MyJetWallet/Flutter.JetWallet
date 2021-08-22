import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../auth/shared/notifiers/auth_info_notifier/auth_info_notifier.dart';
import '../../../auth/shared/notifiers/auth_info_notifier/auth_info_state.dart';
import '../../../router/provider/authorized_stpod/authorized_union.dart';
import '../../../router/provider/router_stpod/router_union.dart';
import '../../../service/services/authentication/model/logout/logout_request_model.dart';
import '../../../service/services/authentication/service/authentication_service.dart';
import '../../../service/services/signal_r/service/signal_r_service.dart';
import '../../logging/levels.dart';
import '../../services/local_storage_service.dart';
import 'logout_union.dart';

class LogoutNotifier extends StateNotifier<LogoutUnion> {
  LogoutNotifier({
    required this.router,
    required this.authorized,
    required this.authInfo,
    required this.authInfoN,
    required this.authService,
    required this.storageService,
    required this.signalRService,
  }) : super(const Result());

  final StateController<RouterUnion> router;
  final StateController<AuthorizedUnion> authorized;
  final AuthInfoState authInfo;
  final AuthInfoNotifier authInfoN;
  final AuthenticationService authService;
  final LocalStorageService storageService;
  final SignalRService signalRService;

  static final _logger = Logger('LogoutNotifier');

  Future<void> logout() async {
    _logger.log(notifier, 'logout');

    try {
      state = const Loading();

      final model = LogoutRequestModel(token: authInfo.token);

      await authService.logout(model);

      await storageService.clearStorage();

      router.state = const Unauthorized();

      authInfoN.resetResendButton();

      // signalRService is initialized after EmailVerification
      if (authorized.state != const EmailVerification()) {
        await signalRService.disconnect();
      }
    } catch (e, st) {
      _logger.log(stateFlow, 'logout', e);
      state = Result(e, st);
    }
  }
}
