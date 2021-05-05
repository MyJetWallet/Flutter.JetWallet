import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/global/translations.dart';
import 'package:jetwallet/state/config/config_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';

Future<void> initLocale(ConfigStorage storage, String deviceLanguage) async {
  var language = deviceLanguage;
  final storedLanguage = await storage.getString('language');

  if (storedLanguage == null || storedLanguage.isEmpty) {
    await storage.setString('language', language);
  } else {
    language = storedLanguage;
  }

  await t.setLanguage(language);
}

Function initBuildVersion() {
  return (Store<AppState> store) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;

    store.dispatch(SetCurrentBuildVersion(version: version, build: buildNumber));
  };
}

class SetCurrentBuildVersion {
  const SetCurrentBuildVersion({
    required this.version,
    required this.build,
  });

  final String version;
  final String build;
}
