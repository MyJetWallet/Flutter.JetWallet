import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../auth/screens/sign_in_up/model/auth_model.dart';
import '../../../../router/provider/router_stpod/router_union.dart';
import '../../../../service/services/authentication/model/logout/logout_request_model.dart';
import '../../../../service/services/authentication/service/authentication_service.dart';
import '../../../../service/services/signal_r/service/signal_r_service.dart';
import '../../../../shared/logging/levels.dart';
import '../../../../shared/services/local_storage_service.dart';
import 'logout_union.dart';

class LogoutNotifier extends StateNotifier<LogoutUnion> {
  LogoutNotifier({
    required this.router,
    required this.authModel,
    required this.authService,
    required this.storageService,
    required this.signalRService,
  }) : super(const Result());

  final StateController<RouterUnion> router;
  final AuthModel authModel;
  final AuthenticationService authService;
  final LocalStorageService storageService;
  final SignalRService signalRService;

  static final _logger = Logger('LogoutNotifier');

  Future<void> logout() async {
    _logger.log(notifier, 'logout');

    try {
      state = const Loading();

      final model = LogoutRequestModel(token: authModel.token);

      await authService.logout(model);

      // remove refreshToken from storage
      await storageService.clearStorage();

      router.state = const Unauthorized();

      await signalRService.disconnect();
      state = const Result();
    } catch (e, st) {
      _logger.log(stateFlow, 'logout', e);
      state = Result(e, st);
    }
  }
}
