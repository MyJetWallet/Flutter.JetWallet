import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

// KEYS
const refreshTokenKey = 'refreshToken';
const userEmailKey = 'userEmail';
const closedSupportBannerKey = 'closedSupportBanner';
const privateKeyKey = 'privateKey';
const pinStatusKey = 'pinStatusKey';
const contactsPermissionKey = 'contactsPermissionKey';
const pinDisabledKey = 'pinDisabledKey';
const bannersIdsKey = 'bannersIds';
const phonebookStatusKey = 'phonebookStatusKey';
const cameraStatusKey = 'cameraStatusKey';
const referralCodeKey = 'referralCodeKey';
const billingInformationKey = 'billingInformationKey';
const firstInitAppCodeKey = 'firstInitAppCodeKey';
const checkedCircle = 'circleWasChecked';
const checkedUnlimint = 'unlimintWasChecked';
const checkedBankCard = 'bankCardWasChecked';
const useBioKey = 'useBio';
const startApp = 'startApp';
const marketOpened = 'marketOpened';
const signalRStarted = 'signalRStarted';
const initFinishedFirstCheck = 'initFinishedFirstCheck';
const initFinishedReceived = 'initFinishedReceived';
const configReceived = 'configReceived';
const timeStartMarketSent = 'timeStartMarketSent';
const timeStartInitFinishedSent = 'timeStartInitFinishedSent';
const timeStartConfigSent = 'timeStartConfigSent';
const timeSignalRCheckIFSent = 'timeSignalRCheckIFSent';
const timeSignalRReceiveIFSent = 'timeSignalRReceiveIFSent';
const initFinishedOnMarketSent = 'initFinishedOnMarketSent';
const lastUsedCard = 'lastUsedCard';
const nftPromoCode = 'nftPromoCode';
const lastUsedMail = 'lastUsedMail';

final sLocalStorageService = getIt.get<LocalStorageService>();

class LocalStorageService {
  final _storage = const FlutterSecureStorage();

  Future<String?> getValue(String key) async {
    return _storage.read(key: key);
  }

  Future<void> setString(String key, String? value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> setList(String key, List<String> list) async {
    await _storage.write(key: key, value: jsonEncode(list));
  }

  Future<void> setJson(String key, Map<String, dynamic> json) async {
    await _storage.write(key: key, value: jsonEncode(json));
  }

  Future<void> clearStorage() async {
    // Add keys you want to delete after logout or unsuccessful token refresh
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: userEmailKey);
    await _storage.delete(key: privateKeyKey);
    await _storage.delete(key: pinStatusKey);
    await _storage.delete(key: contactsPermissionKey);
    await _storage.delete(key: cameraStatusKey);
    await _storage.delete(key: pinDisabledKey);
    await _storage.delete(key: bannersIdsKey);
    await _storage.delete(key: phonebookStatusKey);
    await _storage.delete(key: referralCodeKey);
    await _storage.delete(key: firstInitAppCodeKey);
    await _storage.delete(key: checkedCircle);
    await _storage.delete(key: checkedUnlimint);
    await _storage.delete(key: closedSupportBannerKey);
    await _storage.delete(key: billingInformationKey);
    await _storage.delete(key: checkedCircle);
    await _storage.delete(key: useBioKey);
    await _storage.delete(key: startApp);
    await _storage.delete(key: nftPromoCode);

    await _storage.deleteAll();
  }

  Future<void> clearStorageForCrypto(List<CurrencyModel> currencies) async {
    for (final element in currencies) {
      await _storage.delete(key: element.symbol);
    }
  }

  Future<void> clearTimeTracker() async {
    await _storage.delete(key: startApp);
    await _storage.delete(key: marketOpened);
    await _storage.delete(key: signalRStarted);
    await _storage.delete(key: initFinishedFirstCheck);
    await _storage.delete(key: initFinishedReceived);
    await _storage.delete(key: configReceived);
    await _storage.delete(key: timeStartMarketSent);
    await _storage.delete(key: timeStartInitFinishedSent);
    await _storage.delete(key: timeStartConfigSent);
    await _storage.delete(key: timeSignalRCheckIFSent);
    await _storage.delete(key: timeSignalRReceiveIFSent);
    await _storage.delete(key: initFinishedOnMarketSent);
    await setString('cleared', 'true');
  }

  Future<void> clearedChange() async {
    await _storage.delete(key: 'cleared');
  }
}
