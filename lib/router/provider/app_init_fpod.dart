import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/screens/sign_in_up/provider/auth_model_notipod.dart';
import '../../service_providers.dart';
import '../../shared/helpers/refresh_token.dart';
import '../../shared/services/local_storage_service.dart';
import 'router_stpod/router_stpod.dart';
import 'router_stpod/router_union.dart';

final appInitFpod = FutureProvider<void>((ref) async {
  final router = ref.watch(routerStpod.notifier);
  final authModel = ref.watch(authModelNotipod.notifier);
  final storageService = ref.watch(localStorageServicePod);
  final rsaService = ref.watch(rsaServicePod);

  final token = await storageService.getString(refreshTokenKey);
  final email = await storageService.getString(userEmailKey);

  await rsaService.init();
  await rsaService.savePrivateKey(storageService);

  if (token == null) {
    router.state = const Unauthorized();
  } else {
    authModel.updateRefreshToken(token);
    authModel.updateEmail(email ?? '<Email not found>');

    try {
      final result = await refreshToken(ref.read);

      if (result == RefreshTokenStatus.success) {
        router.state = const Authorized();
      } else {
        router.state = const Unauthorized();
      }
    } catch (e) {
      router.state = const Unauthorized();
    }
  }
});
