import 'package:jetwallet/global/translations.dart';
import 'package:jetwallet/state/config/config_storage.dart';

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
