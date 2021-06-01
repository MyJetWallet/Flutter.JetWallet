import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/providers/auth_model_notipod.dart';
import '../../service/services/authentication/model/refresh/auth_refresh_request_model.dart';
import '../../service_providers.dart';
import '../../shared/services/local_storage_service.dart';
import 'router_stpod.dart';
import 'union/router_union.dart';

final routerFpod = FutureProvider<void>((ref) async {
  final router = ref.watch(routerStpod.notifier);
  final authModel = ref.watch(authModelNotipod.notifier);
  final storageService = ref.watch(localStorageServicePod);
  final authService = ref.watch(authServicePod);

  final refreshToken = await storageService.getString(refreshTokenKey);

  if (refreshToken == null) {
    router.state = const Unauthorised();
  } else {
    try {
      final model = AuthRefreshRequestModel(
        refreshToken: refreshToken,
      );

      final response = await authService.refresh(model);

      await storageService.setString(refreshTokenKey, response.refreshToken);

      authModel.updateToken(response.token);
      authModel.updateRefreshToken(response.refreshToken);

      router.state = const Authorised();
    } catch (e) {
      router.state = const Unauthorised();

      // remove refreshToken from storage
      await storageService.clearStorage();
    }
  }
});
