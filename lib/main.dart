import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'api/dio_client.dart';
import 'api/spot_wallet_client.dart';
import 'main_app.dart';
import 'signal_r/signal_r_service.dart';
import 'state/config/config_actions.dart';
import 'state/config/config_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final spotWalletClient = SpotWalletClient(DioClient());
  Injector.appInstance
      .registerDependency<SpotWalletClient>(() => spotWalletClient);

  final configStorage = ConfigStorage();
  Injector.appInstance.registerDependency<ConfigStorage>(() => configStorage);

  //TODO(Vova): fix localization. Currently it doesn't work on Web.
  // #730 Don't delete the line bellow. Platform.localeName requires some delay on iOS
  // to get localization string. Otherwise it's null
  // await Future<dynamic>.delayed(const Duration(seconds: 1));
  // final locale = Platform.localeName.split('').take(2).join().toString();
  // await initLocale(configStorage, locale);

  final store = buildStore()..dispatch(initBuildVersion());

  final signalRService = SignalRService(store);
  Injector.appInstance.registerDependency<SignalRService>(() => signalRService);

  runApp(
    MainApp(
      store: store,
    ),
  );
}
