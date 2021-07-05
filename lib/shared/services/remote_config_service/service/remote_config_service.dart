import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../../../service/shared/api_urls.dart';
import '../model/connection_config_model.dart';

class RemoteConfigService {
  final _config = RemoteConfig.instance;

  Future<void> fetchAndActivate() async {
    await _config.fetchAndActivate();
  }

  ConnectionFlavorsModel get connectionFlavors {
    final flavors = _config.getString('ConnectionFlavors');

    final list = jsonDecode(flavors) as List;

    return ConnectionFlavorsModel.fromList(list);
  }

  /// Each index respresents different flavor (backend environment)
  void overrideApisFrom(int index) {
    final flavor = connectionFlavors.flavors[index];

    tradingAuthApi = flavor.tradingAuthApi;
    walletApi = flavor.walletApi;
    tradingApi = flavor.tradingApi;
    validationApi = flavor.validationApi;
  }
}
