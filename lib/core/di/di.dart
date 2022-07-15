import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/router/guards/init_guard.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../services/simple_networking/simple_networking.dart';
import 'di.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  asExtension: true,
  initializerName: 'init',
)
Future<GetIt> getItInit({
  String? env,
  EnvironmentFilter? environmentFilter,
}) async {
  getIt.registerSingleton<SimpleKit>(
    SimpleKit(),
  );

  /*
  getIt.registerSingleton<AppLocalizations>(
    AppLocalizations.of(getIt.get<AppRouter>().navigatorKey.currentContext!)!,
  );
  */

  getIt.registerLazySingleton<SNetwork>(
    () => SNetwork(),
  );

  getIt.registerSingletonAsync<RemoteConfig>(
    () async => RemoteConfig().fetchAndActivate(),
    dependsOn: [],
  );

  getIt.registerSingleton<AppStore>(
    AppStore(),
  );

  getIt.registerSingletonWithDependencies<SimpleAnalytics>(
    () => SimpleAnalytics(),
    dependsOn: [RemoteConfig],
  );

  getIt.registerSingleton<AppRouter>(
    AppRouter(initGuard: InitGuard()),
  );

  return getIt.init(
    environmentFilter: environmentFilter,
    environment: env,
  );
}

void resetGetIt<T extends Object>({
  Object? instance,
  String? instanceName,
  void Function(T)? disposingFunction,
}) {
  getIt.resetLazySingleton<T>(
    instance: instance,
    instanceName: instanceName,
    disposingFunction: disposingFunction,
  );
}
