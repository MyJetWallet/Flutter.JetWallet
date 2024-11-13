import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

///
/// KEYS
///
/// Persistent keys (these variables remain stored even after deleting other data)
///
const lastUsedMail = 'lastUsedMail';
const activeSlot = 'activeSlot';
const deviceId = 'deviceId';
const isCardBannerClosed = 'isCardBannerClosed';
const userLocale = 'userLocale';
const showRateUp = 'showRateUp';
const rateUpCount = 'rateUpCount';
const spareDeviceId = 'spareDeviceId';
const utmSourceKey = 'utm_source';
const installConversionDataKey = 'installConversionData';
const onelinkDataKey = 'onelinkData';
const campaignKey = 'campaign';
const mediaSourceKey = 'mediaSource';
///
/// Non-persistent keys (these variables can be deleted and restored when needed)
///
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
const checkedLocalTerms = 'localWasChecked';
const checkedP2PTerms = 'p2pCardWasChecked';
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
const lastAssetSend = 'lastAssetSend';
const bankLastMethodId = 'bankLastMethodId';
const localLastMethodId = 'localLastMethodId';
const p2pLastMethodId = 'p2pLastMethodId';
const earnTermsAndConditionsWasChecked = 'earnTermsAndConditionsWasChecked';
const isPerapaidCardBannerClosed = 'isPerapaidCardBannerClosed';
const isJarTermsConfirmed = 'isJarTermsConfirmed';
const isJarsLandingClosed = 'isJarsLandingClosed';

final sLocalStorageService = getIt.get<LocalStorageService>();

class LocalStorageService {
  LocalStorageService() {
    checkIsFirstRun();
  }

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

  Future<void> deleteAllWithoutPermanentData() async {
    final userMail = await _storage.read(key: lastUsedMail);
    final slot = await _storage.read(key: activeSlot);
    final deviceIdUsed = await _storage.read(key: deviceId);
    final isCardBannerClosedUsed = await _storage.read(key: isCardBannerClosed);
    final userLocaleTemp = await _storage.read(key: userLocale);
    final showRateUpTemp = await _storage.read(key: showRateUp);
    final rateUpCountTemp = await _storage.read(key: rateUpCount);
    final spareDeviceIdTemp = await _storage.read(key: spareDeviceId);
    final utmSourceTemp = await _storage.read(key: utmSourceKey);
    final installConversionDataTemp = await _storage.read(key: installConversionDataKey);
    final onelinkDataTemp = await _storage.read(key: onelinkDataKey);
    final campaignTemp = await _storage.read(key: campaignKey);
    final mediaSourceTemp = await _storage.read(key: mediaSourceKey);

    await _storage.deleteAll();
    await _storage.write(key: lastUsedMail, value: userMail);
    await _storage.write(key: activeSlot, value: slot);
    await _storage.write(key: deviceId, value: deviceIdUsed);
    await _storage.write(
      key: isCardBannerClosed,
      value: isCardBannerClosedUsed,
    );
    await _storage.write(key: userLocale, value: userLocaleTemp);
    await _storage.write(key: showRateUp, value: showRateUpTemp);
    await _storage.write(key: rateUpCount, value: rateUpCountTemp);
    await _storage.write(key: spareDeviceId, value: spareDeviceIdTemp);
    await _storage.write(key: utmSourceKey, value: utmSourceTemp);
    await _storage.write(key: installConversionDataKey, value: installConversionDataTemp);
    await _storage.write(key: onelinkDataKey, value: onelinkDataTemp);
    await _storage.write(key: campaignKey, value: campaignTemp);
    await _storage.write(key: mediaSourceKey, value: mediaSourceTemp);
  }

  Future<void> clearStorage() async {
    ///
    /// TODO: QUESTION
    /// Should we individually delete each key if we are already using the deleteAllWithoutPermanentData function?
    ///
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
    await _storage.delete(key: activeSlot);
    await _storage.delete(key: lastAssetSend);
    await _storage.delete(key: bankLastMethodId);
    await _storage.delete(key: localLastMethodId);
    await _storage.delete(key: p2pLastMethodId);
    await _storage.delete(key: earnTermsAndConditionsWasChecked);
    await _storage.delete(key: isJarTermsConfirmed);
    await _storage.delete(key: initFinishedFirstCheck);

    await deleteAllWithoutPermanentData();
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

  Future<void> checkIsFirstRun() async {
    final val = await getIt<LocalCacheService>().checkIsFirstRunning();

    if (val) {
      getIt<AppStore>().setAfterInstall(true);

      await deleteAllWithoutPermanentData();
    }
  }

  Future<void> forceClearStorage() async {
    await _storage.deleteAll();
  }

  Future<void> deleteValueByKey(String key) async {
    await _storage.delete(key: key);
  }
}
