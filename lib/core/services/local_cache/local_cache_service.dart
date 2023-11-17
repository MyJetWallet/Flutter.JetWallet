import 'dart:convert';

import 'package:charts/simple_chart.dart';
import 'package:jetwallet/core/services/local_cache/models/cache_candles.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_networking/modules/remote_config/models/remote_config_model.dart';

/// The service is responsible for caching internal data in
/// the application and store user data
const String isFirstRunning = 'isFirstRunning';
const String signalRCache = 'signalRCache';
const String chartCandles = 'chartCandles';
const String isBalanceHide = 'isBalanceHide';
const String hideZeroBalance = 'hideZeroBalance';
const String installID = 'installID';
const String globalSendConditions = 'globalSendConditions';
const String isGiftPolicyAgreed = 'isGiftPolicyAgreed';
const String isBiometricsHided = 'isBiometricsHided';

const String remoteConfig = 'remoteConfigCache';

class LocalCacheService {
  late SharedPreferences instance;

  Future<LocalCacheService> init() async {
    instance = await SharedPreferences.getInstance();

    return this;
  }

  ///

  Future<void> saveInstallID(String value) async {
    await instance.setString(installID, value);
  }

  Future<String?> getInstallID() async {
    return instance.getString(installID);
  }

  ///

  Future<void> saveRemoteConfig(RemoteConfigModel model) async {
    await instance.setString(remoteConfig, jsonEncode(model.toJson()));
  }

  Future<RemoteConfigModel?> getRemoteConfig() async {
    final data = instance.getString(remoteConfig);

    return data != null
        ? RemoteConfigModel.fromJson(
            jsonDecode(data) as Map<String, dynamic>,
          )
        : null;
  }

  ///

  Future<void> saveGlobalSendConditions(bool value) async {
    await instance.setBool(globalSendConditions, value);
  }

  Future<bool?> getGlobalSendConditions() async {
    return instance.getBool(globalSendConditions);
  }

  ///

  Future<void> saveBalanceHide(bool value) async {
    await instance.setBool(isBalanceHide, value);
  }

  Future<bool?> getBalanceHide() async {
    return instance.getBool(isBalanceHide);
  }

  ///

  Future<void> saveHideZeroBalance(bool value) async {
    await instance.setBool(hideZeroBalance, value);
  }

  Future<bool?> getHideZeroBalance() async {
    return instance.getBool(hideZeroBalance);
  }

  ///

  Future<void> saveGiftPolicyAgreed(bool value) async {
    await instance.setBool(isGiftPolicyAgreed, value);
  }

  Future<bool?> getGiftPolicyAgreed() async {
    return instance.getBool(isGiftPolicyAgreed);
  }

  ///

  Future<void> saveBiometricHided(bool value) async {
    await instance.setBool(isBiometricsHided, value);
  }

  Future<bool?> getBiometricHided() async {
    return instance.getBool(isBiometricsHided);
  }

  ///

  Future<bool> checkIsFirstRunning() async {
    final val = instance.getBool(isFirstRunning);

    if (val == false || val == null) {
      await instance.setBool(isFirstRunning, true);

      return true;
    } else {
      return false;
    }
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

      final checkIsHaveAsset = localList.indexWhere((element) => element.asset == asset);
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

      final checkIsHaveAsset = actualCacheModel.data.indexWhere((element) => element.asset == asset);

      return checkIsHaveAsset != -1 ? actualCacheModel.data[checkIsHaveAsset] : null;
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
