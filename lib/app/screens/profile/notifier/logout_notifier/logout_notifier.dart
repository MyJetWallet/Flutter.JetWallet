import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../auth/model/auth_model.dart';
import '../../../../../router/provider/union/router_union.dart';
import '../../../../../service/services/authentication/model/logout/logout_request_model.dart';
import '../../../../../service/services/authentication/service/authentication_service.dart';
import '../../../../../service/services/signal_r/service/signal_r_service.dart';
import '../../../../../shared/services/local_storage_service.dart';
import 'union/logout_union.dart';

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

  Future<void> logout() async {
    try {
      state = const Loading();

      final model = LogoutRequestModel(token: authModel.token);

      await authService.logout(model);

      // remove refreshToken from storage
      await storageService.clearStorage();

      router.state = const Unauthorised();

      await signalRService.disconnect();
      state = const Result();
    } catch (e, st) {
      state = Result(e, st);
    }
  }
}
