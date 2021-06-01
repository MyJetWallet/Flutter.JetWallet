import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../auth/model/auth_model.dart';
import '../../../../../router/providers/union/router_union.dart';
import '../../../../../service/services/authentication/model/logout/logout_request_model.dart';
import '../../../../../service/services/authentication/service/authentication_service.dart';
import '../../../../../shared/services/local_storage_service.dart';
import 'union/logout_union.dart';

class LogoutNotifier extends StateNotifier<LogoutUnion> {
  LogoutNotifier({
    required this.router,
    required this.authModel,
    required this.authService,
    required this.storageService,
  }) : super(const Result());

  final StateController<RouterUnion> router;
  final AuthModel authModel;
  final AuthenticationService authService;
  final LocalStorageService storageService;

  Future<void> logout() async {
    try {
      state = const Loading();

      final model = LogoutRequestModel(token: authModel.token);

      await authService.logout(model);

      // remove token and refreshToken from storage
      await storageService.clearStorage();

      router.state = const Unauthorised();
      state = const Result();
    } catch (e, st) {
      state = Result(e, st);
    }
  }
}
