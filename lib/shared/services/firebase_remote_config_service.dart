import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../service/shared/api_urls.dart';

Future<void> overrideBaseUrls() async {
  final remoteConfig = RemoteConfig.instance;
  await remoteConfig.fetch();

  tradingAuthBaseUrl = remoteConfig.getString('tradingAuthBaseUrl');
  walletApiBaseUrl = remoteConfig.getString('walletApiBaseUrl');
  tradingBaseUrl = remoteConfig.getString('tradingBaseUrl');
}
