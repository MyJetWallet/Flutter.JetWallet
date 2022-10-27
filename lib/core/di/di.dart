import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/router/guards/init_guard.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/payment_methods_service/payment_methods_service.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_with_hidden_service.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/dynamic_link_service.dart';
import 'package:jetwallet/core/services/internet_checker_service.dart';
import 'package:jetwallet/core/services/kyc_profile_countries.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/store/kyc_profile_countries_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_confirm_store.dart';
import 'package:jetwallet/features/nft/nft_confirm/store/nft_promo_code_store.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_confirm_store.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/core/simple_kit.dart';

import '../../features/kyc/kyc_service.dart';
import '../services/simple_networking/simple_networking.dart';
import 'di.config.dart';

final GetIt getIt = GetIt.instance;

final _logger = Logger('DI');

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

  _logger.log(stateFlow, 'SIMPLE KIT LOADED');

  /*
  getIt.registerSingleton<AppLocalizations>(
    AppLocalizations.of(getIt.get<AppRouter>().navigatorKey.currentContext!)!,
  );
  */

  getIt.registerSingletonAsync<PackageInfoService>(
    () async => PackageInfoService().init(),
  );

  _logger.log(stateFlow, 'PackageInfoService LOADED');

  getIt.registerSingletonAsync<RemoteConfig>(
    () async => RemoteConfig().fetchAndActivate(),
    dependsOn: [PackageInfoService],
  );

  _logger.log(stateFlow, 'RemoteConfig LOADED');

  getIt.registerSingleton<SNetwork>(
    SNetwork(),
  );

  _logger.log(stateFlow, 'SNetwork LOADED');

  getIt.registerSingletonWithDependencies<SimpleAnalytics>(
    () => SimpleAnalytics(),
    dependsOn: [RemoteConfig],
  );

  _logger.log(stateFlow, 'SimpleAnalytics LOADED');

  getIt.registerSingleton<AppRouter>(
    AppRouter(initGuard: InitGuard()),
  );

  _logger.log(stateFlow, 'AppRouter LOADED');

  getIt.registerSingleton<SignalRService>(
    SignalRService(),
  );

  _logger.log(stateFlow, 'SignalRService LOADED');

  /*
  getIt.registerSingleton<SignalRModules>(
    SignalRModules(),
  );
  */

  //getIt.registerLazySingleton<KycService>(() => KycService());

  getIt.registerSingleton<PaymentMethodService>(
    PaymentMethodService(),
  );

  getIt.registerSingleton<CurrenciesService>(
    CurrenciesService(),
  );

  _logger.log(stateFlow, 'CurrenciesService LOADED');

  getIt.registerSingleton<CurrenciesWithHidden>(
    CurrenciesWithHidden(),
  );

  getIt.registerLazySingleton<LogoutService>(() => LogoutService());

  getIt.registerSingleton<DeepLinkService>(
    DeepLinkService(),
  );

  getIt.registerLazySingleton<KycProfileCountriesStore>(
    () => KycProfileCountriesStore(),
  );

  getIt.registerLazySingleton<ReferallCodeStore>(
    () => ReferallCodeStore()..init(),
  );

  _logger.log(stateFlow, 'ReferallCodeStore LOADED');

  getIt.registerLazySingleton<WithdrawalConfirmStore>(
    () => WithdrawalConfirmStore(),
  );

  getIt.registerLazySingleton<SendByPhoneConfirmStore>(
    () => SendByPhoneConfirmStore(),
  );

  getIt.registerLazySingleton<NFTPromoCodeStore>(() => NFTPromoCodeStore());

  //getIt.registerSingleton<AppStore>(
  //  AppStore(),
  //);

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
