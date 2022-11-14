import 'dart:convert';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts/simple_chart.dart';

/// The service is responsible for caching internal data in the application

const String signalRCache = 'signalRCache';
const String chartCandles = 'chartCandles';

class LocalCacheService {
  late SharedPreferences instance;

  Future<LocalCacheService> init() async {
    instance = await SharedPreferences.getInstance();

    return this;
  }

  ///

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

  ///

  Future<void> saveChart(String asset, List<CandleModel>? candle) async {
    //instance.getStringList(key)
  }

  ///

  Future<void> clearAllCache() async {
    await instance.clear();
  }
}
