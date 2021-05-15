import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/providers/authentication_model_stpod.dart';
import '../../shared/services/local_storage_service.dart';
import 'router_stpod.dart';
import 'union/router_union.dart';

final routerFpod = FutureProvider<void>((ref) async {
  final router = ref.read(routerStpod);
  final authModel = ref.read(authenticationModelStpod);

  final token = await LocalStorageService().getString(tokenKey);
  final refreshToken = await LocalStorageService().getString(refreshTokenKey);

  if (token == null || refreshToken == null) {
    router.state = const Unauthorised();
  } else {
    authModel.state = authModel.state.copyWith(
      token: token,
      refreshToken: refreshToken,
    );
    router.state = const Authorised();
  }
});
