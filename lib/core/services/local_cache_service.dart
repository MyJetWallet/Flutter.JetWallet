import 'dart:convert';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The service is responsible for caching internal data in the application

const String signalRCache = 'signalRCache';

class LocalCacheService {
  late SharedPreferences instance;

  Future<LocalCacheService> init() async {
    instance = await SharedPreferences.getInstance();

    return this;
  }

  Future<void> saveSignalR(Map<String, dynamic> json) async {
    await instance.setString(signalRCache, jsonEncode(json));
  }

  Future<SignalRServiceUpdated?> getSignalRFromCache() async {
    final data = instance.getString(signalRCache);

    return data != null
        ? SignalRServiceUpdated.fromJson(
            jsonDecode(data) as Map<String, dynamic>,
          )
        : null;
  }

  Future<void> clearAllCache() async {
    await instance.clear();
  }
}
