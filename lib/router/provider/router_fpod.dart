import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/screens/sign_in_up/provider/auth_model_notipod.dart';
import '../../service_providers.dart';
import '../../shared/helpers/refresh_token.dart';
import '../../shared/services/local_storage_service.dart';
import 'router_stpod/router_stpod.dart';
import 'router_stpod/router_union.dart';

final routerFpod = FutureProvider<void>((ref) async {
  final router = ref.watch(routerStpod.notifier);
  final authModel = ref.watch(authModelNotipod.notifier);
  final storageService = ref.watch(localStorageServicePod);

  final token = await storageService.getString(refreshTokenKey);

  if (token == null) {
    router.state = const Unauthorised();
  } else {
    authModel.updateRefreshToken(token);

    try {
      final result = await refreshToken(ref.read);

      if (result == RefreshTokenStatus.success) {
        router.state = const Authorised();
      }
    } catch (e) {
      // TODO handle this flow (waiting for product owners)
      throw """
      You saw this error at the LAUNCH of the app because:
      1) You don't have an Interent Connection and we couldn't refresh your token hence we couldn't verify it's you.
      2) Or something really bad happend.

      Steps to solve this problem:
      1) Enable internet connection
      2) Restart your app.

      And in case you are really curios what the problem is: 
      $e
          """;
    }
  }
});
