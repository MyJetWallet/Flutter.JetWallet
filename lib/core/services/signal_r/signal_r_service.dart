import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_client.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/helpers/get_user_agent.dart';
import 'package:simple_networking/modules/signal_r/models/signalr_log.dart';
import 'package:simple_networking/modules/signal_r/signal_r_new.dart';
import 'package:simple_networking/modules/signal_r/signal_r_transport.dart';
import 'package:simple_networking/simple_networking.dart';
import 'package:logger/logger.dart';

const String signalRSingletinName = 'SignalRModuleNew';

class SignalRService {
  //late SignalRModule signalR;
  SignalRModuleNew? signalR;

  final _logger = getIt.get<SimpleLoggerService>();
  final _loggerValue = 'SignalRService';

  /// CreateService and Start Init
  Future<void> start() async {
    await _getSignalRModule();

    //await signalR!.openConnection();

    getIt.registerSingletonAsync<SignalRModuleNew>(
      () async {
        final service = await createNewService();
        await service.openConnection();

        await service.checkConnectionTimer();

        return service;
      },
      instanceName: 'SignalRModuleNew',
    );

    // Save handler
    //await Future.delayed(const Duration(milliseconds: 500), () async {
    //  await getIt.get<SignalRModuleNew>().checkConnectionTimer();
    //});

    //GetIt.I.resetLazySingleton(instanceName: signalRSingletinName);
  }

  Future<void> reCreateSignalR() async {
    try {
      if (signalR != null) {
        await signalR!.disconnect('reCreateSignalR');
      } else {
        signalR = await createNewService();
      }
    } catch (e) {
      signalR = await createNewService();
    }

    await signalR!.openConnection();

    // Save handler
    await signalR!.checkConnectionTimer();
  }

  Future<void> forceReconnectSignalR() async {
    await killSignalR();
    return;
    if (signalR != null) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.wtf,
            place: 'SignalRService',
            message: 'forceReconnectSignalR',
          );

      await signalR!.disconnect('reCreateSignalR', force: true);
    }

    signalR = null;

    await Future.delayed(const Duration(milliseconds: 100));

    signalR = await createNewService();
    await signalR!.openConnection();

    // Save handler
    await signalR!.checkConnectionTimer();
  }

  Future<void> killSignalR() async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.warning,
          place: 'SignalRService',
          message: 'KillSignalR Func',
        );

    signalR = null;

    await getIt.unregister<SignalRModuleNew>(
      instanceName: signalRSingletinName,
      disposingFunction: (p0) {
        p0.dispose();
      },
    );

    await Future.delayed(const Duration(milliseconds: 560), () {
      start();
    });
  }

  Future<void> _getSignalRModule() async {
    try {
      final sRCache = await getIt<LocalCacheService>().getSignalRFromCache();

      _logger.log(
        level: Level.info,
        place: _loggerValue,
        message: 'sRCache is ${sRCache == null}',
      );

      sSignalRModules = sRCache ?? SignalRServiceUpdated();
    } catch (e) {
      sSignalRModules = SignalRServiceUpdated();
    }
  }

  Future<SignalRModuleNew> createNewService() async {
    final transport = SignalRTransport(
      initFinished: sSignalRModules.setInitFinished,
      cards: sSignalRModules.setCards,
      cardLimits: sSignalRModules.setCardLimitModel,
      earnOffersList: sSignalRModules.setEarnOffersList,
      earnProfile: sSignalRModules.setEarnProfile,
      operationHistory: sSignalRModules.operationHistoryEvent,
      recurringBuys: sSignalRModules.setRecurringBuys,
      kycCountries: sSignalRModules.setKYCCountries,
      marketInfo: sSignalRModules.setMarketInfo,
      marketCampaigns: sSignalRModules.setMarketCampaigns,
      referralStats: sSignalRModules.setReferralStats,
      instruments: sSignalRModules.setInstruments,
      marketItems: sSignalRModules.setMarketItems,
      periodPrices: sSignalRModules.setPeriodPrices,
      clientDetail: sSignalRModules.setClientDetail,
      keyValue: sSignalRModules.setKeyValue,
      indicesDetails: sSignalRModules.setIndicesDetails,
      priceAccuracies: sSignalRModules.setPriceAccuracies,
      referralInfo: sSignalRModules.setReferralInfo,
      nftList: sSignalRModules.setNFTList,
      nftMarket: sSignalRModules.setNFTMarket,
      userNFTPortfolio: sSignalRModules.setUserNFTPortfolio,
      updateUserNft: sSignalRModules.updateUserNft,
      fireblockEventAction: sSignalRModules.fireblockEventAction,
      setAssets: sSignalRModules.setAssets,
      updateBalances: sSignalRModules.updateBalances,
      updateBlockchains: sSignalRModules.updateBlockchains,
      updateBasePrices: sSignalRModules.updateBasePrices,
      updateAssetsWithdrawalFees: sSignalRModules.updateAssetsWithdrawalFees,
      updateAssetPaymentMethods: sSignalRModules.updateAssetPaymentMethods,
      updateAssetPaymentMethodsNew:
          sSignalRModules.updateAssetPaymentMethodsNew,

      ///
      createNewSessionLog: () {
        sSignalRModules.signalRLogs.add(
          SignalrLog(
            sessionTime: DateTime.now(),
            logs: [
              SLogData(
                type: SLogType.startConnection,
                date: DateTime.now(),
              ),
            ],
          ),
        );
      },
      addToPing: (DateTime time) {
        if (sSignalRModules.signalRLogs.isNotEmpty) {
          final temp = sSignalRModules.signalRLogs.last.logs;
          temp!.add(
            SLogData(
              type: SLogType.ping,
              date: time,
            ),
          );

          sSignalRModules.signalRLogs.last =
              sSignalRModules.signalRLogs.last.copyWith(
            logs: temp,
          );
        }
      },
      addToPong: (DateTime time) {
        if (sSignalRModules.signalRLogs.isNotEmpty) {
          final temp = sSignalRModules.signalRLogs.last.logs;
          temp!.add(
            SLogData(
              type: SLogType.pong,
              date: time,
            ),
          );

          sSignalRModules.signalRLogs.last =
              sSignalRModules.signalRLogs.last.copyWith(
            logs: temp,
          );
        }
      },
      addToLog: (DateTime time, String error) {
        if (sSignalRModules.signalRLogs.isNotEmpty) {
          final temp = sSignalRModules.signalRLogs.last.logs;
          temp!.add(
            SLogData(
              type: SLogType.error,
              date: time,
              error: error,
            ),
          );

          sSignalRModules.signalRLogs.last =
              sSignalRModules.signalRLogs.last.copyWith(
            logs: temp,
          );
        }
      },
      updateGlobalSendMethods: sSignalRModules.setGlobalSendMethods,
    );

    _logger.log(
      level: Level.info,
      place: _loggerValue,
      message:
          'CREATE SIGNALR MODULE\nToken: ${getIt.get<AppStore>().authState.token}\n',
    );

    return SignalRModuleNew(
      options: getIt.get<SNetwork>().simpleOptions,
      deviceUid: getIt.get<DeviceInfo>().deviceUid,
      localeName: intl.localeName,
      refreshToken: refreshToken,
      transport: transport,
      log: _logger.log,
      getToken: _getToken,
      signalRClient: SignalRClient(
        defaultHeaders: {
          'User-Agent': await getUserAgent(),
        },
      ),
      forceReconnect: () {
        _logger.log(
          level: Level.warning,
          place: _loggerValue,
          message: 'SIGNALR FORCE RECONNECT',
        );

        forceReconnectSignalR();
      },
    );
  }
}

Future<String> _getToken() async {
  return getIt.get<AppStore>().authState.token;
}
