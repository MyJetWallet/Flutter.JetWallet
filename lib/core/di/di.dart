import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/force_update_service.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/sentry_service.dart';
import 'package:jetwallet/core/services/session_check_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_conection_url_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/splash_error/splash_error_service.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/store/kyc_profile_countries_store.dart';
import 'package:jetwallet/features/auth/verification_reg/store/verification_store.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/core/simple_kit.dart';

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
  getIt.registerSingleton<AppRouter>(
    AppRouter(),
  );

  getIt.registerLazySingleton<SimpleKit>(
    () => SimpleKit(),
  );

  getIt.registerLazySingleton<EventBus>(
    () => EventBus(),
  );

  getIt.registerLazySingleton<StartupService>(
    () => StartupService(),
  );

  getIt.registerSingleton<SimpleLoggerService>(
    SimpleLoggerService(),
  );

  getIt.registerSingleton<SplashErrorService>(
    SplashErrorService(),
  );

  getIt.registerSingletonAsync<LocalCacheService>(
    () async => LocalCacheService().init(),
  );

  getIt.registerSingletonWithDependencies<LocalStorageService>(
    () => LocalStorageService(),
    dependsOn: [LocalCacheService],
  );

  getIt.registerSingletonWithDependencies<AppStore>(
    () => AppStore()
      ..setEnv(env ?? '')
      ..initLocale(),
    dependsOn: [LocalStorageService],
  );

  getIt.registerLazySingleton<RouteQueryService>(
    () => RouteQueryService(),
  );

  getIt.registerSingletonAsync<PackageInfoService>(
    () async => PackageInfoService().init(),
  );

  getIt.registerSingletonAsync<RemoteConfig>(
    () async => RemoteConfig().fetchAndActivate(),
    dependsOn: [PackageInfoService],
  );
  getIt.registerSingleton<SNetwork>(
    SNetwork(),
  );

  getIt.registerSingletonWithDependencies<SimpleAnalytics>(
    () => SimpleAnalytics(),
    dependsOn: [RemoteConfig],
  );

  getIt.registerSingletonWithDependencies<SignalRService>(
    () => SignalRService(),
    dependsOn: [RemoteConfig],
  );

  getIt.registerLazySingleton<LogoutService>(() => LogoutService());

  getIt.registerLazySingleton<KycProfileCountriesStore>(
    () => KycProfileCountriesStore(),
  );

  getIt.registerLazySingleton<ReferallCodeStore>(
    () => ReferallCodeStore()..init(),
  );

  getIt.registerSingletonWithDependencies<UserInfoService>(
    () => UserInfoService(),
    dependsOn: [LocalStorageService],
  );

  getIt.registerSingleton<DeepLinkService>(
    DeepLinkService(),
  );

  getIt.registerSingleton<ForceServiceUpdate>(
    ForceServiceUpdate(),
  );

  getIt.registerLazySingleton<VerificationStore>(
    () => VerificationStore(),
  );

  getIt.registerLazySingleton<SessionCheckService>(
    () => SessionCheckService(),
  );

  getIt.registerLazySingleton<GlobalLoader>(
    () => GlobalLoader(),
  );

  getIt.registerSingletonAsync<IntercomService>(
    () async => IntercomService().init(),
  );

  getIt.registerLazySingleton<BottomBarStore>(
    () => BottomBarStore(),
  );

  getIt.registerLazySingleton<SignalRConecrionUrlService>(
    () => SignalRConecrionUrlService(),
  );

  getIt.registerSingleton<SentryService>(
    SentryService(environment: env ?? 'stage'),
  );

  return getIt.init(
    environmentFilter: environmentFilter,
    environment: env,
  );
}
