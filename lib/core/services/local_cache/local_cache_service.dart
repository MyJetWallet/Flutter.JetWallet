import 'dart:convert';

import 'package:jetwallet/core/services/local_cache/models/cache_candles.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts/simple_chart.dart';

/// The service is responsible for caching internal data in the application

const String isFirstRunning = 'isFirstRunning';
const String signalRCache = 'signalRCache';
const String chartCandles = 'chartCandles';

class LocalCacheService {
  late SharedPreferences instance;

  Future<LocalCacheService> init() async {
    instance = await SharedPreferences.getInstance();

    return this;
  }

  ///

  Future<bool> checkIsFirstRunning() async {
    final val = instance.getBool(isFirstRunning);

    if (val == false) {
      await instance.setBool(isFirstRunning, true);

      return true;
    } else {
      return false;
    }
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

  Future<void> saveChart(
    String asset,
    Map<String, List<CandleModel>?> candle,
  ) async {
    final val = CacheCandlesModel(asset: asset, candle: candle);

    final actualCache = instance.getString(chartCandles);

    if (actualCache != null) {
      var actualCacheModel = CacheCandles.fromJson(
        jsonDecode(actualCache) as Map<String, dynamic>,
      );

      final localList = actualCacheModel.data.toList();

      final checkIsHaveAsset =
          localList.indexWhere((element) => element.asset == asset);
      if (checkIsHaveAsset == -1) {
        localList.add(val);
      } else {
        localList.removeAt(checkIsHaveAsset);
        localList.add(val);
      }

      actualCacheModel = actualCacheModel.copyWith(
        data: localList,
      );

      await instance.setString(
        chartCandles,
        jsonEncode(actualCacheModel.toJson()),
      );
    } else {
      final cacheModel = CacheCandles(data: [val]);

      await instance.setString(
        chartCandles,
        jsonEncode(cacheModel.toJson()),
      );
    }
  }

  Future<CacheCandlesModel?> getChart(String asset) async {
    final actualCache = instance.getString(chartCandles);

    if (actualCache != null) {
      final actualCacheModel = CacheCandles.fromJson(
        jsonDecode(actualCache) as Map<String, dynamic>,
      );

      final checkIsHaveAsset =
          actualCacheModel.data.indexWhere((element) => element.asset == asset);

      return checkIsHaveAsset != -1
          ? actualCacheModel.data[checkIsHaveAsset]
          : null;
    } else {
      return null;
    }
  }

  ///

  Future<void> clearAllCache() async {
    await instance.clear();
    await instance.setBool(isFirstRunning, true);
  }
}
