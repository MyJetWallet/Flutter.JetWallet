import 'dart:async';

import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_client.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_conection_url_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/helpers/get_user_agent.dart';
import 'package:logger/logger.dart';
import 'package:simple_networking/modules/signal_r/models/signalr_log.dart';
import 'package:simple_networking/modules/signal_r/signal_r_new.dart';
import 'package:simple_networking/modules/signal_r/signal_r_transport.dart';

const String signalRSingletinName = 'SignalRModuleNew';

class SignalRService {
  final _logger = getIt.get<SimpleLoggerService>();
  final _loggerValue = 'SignalRService';

  bool isRegisterSingleton = false;

  /// CreateService and Start Init
  Future<void> start({bool isInit = true}) async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.warning,
          place: 'SignalRService',
          message: 'Start SignalR Service, isInit: $isInit',
        );

    if (isInit) {
      await _getSignalRModule();
    }

    if (!getIt.isRegistered<SignalRModuleNew>(
          instanceName: signalRSingletinName,
        ) &&
        !isRegisterSingleton) {
      try {
        isRegisterSingleton = true;
        getIt.registerSingleton<SignalRModuleNew>(
          await createNewService(),
          instanceName: signalRSingletinName,
        );
        final service = getIt<SignalRModuleNew>(instanceName: signalRSingletinName);
        await service.openConnection();
      } catch (e) {
        await forceReconnectSignalR();
      }
    } else {
      await forceReconnectSignalR();
    }
  }

  Future<void> forceReconnectSignalR() async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.warning,
          place: 'SignalRService',
          message: 'Force Reconnect SignalR',
        );

    try {
      if (getIt.isRegistered<SignalRModuleNew>(
        instanceName: signalRSingletinName,
      )) {
        isRegisterSingleton = false;
        await getIt.unregister<SignalRModuleNew>(
          instanceName: signalRSingletinName,
          disposingFunction: (p0) {
            p0.dispose();
          },
        );
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'SignalRService',
            message: 'Force Reconnect Error 1: $e',
          );
    }

    await Future.delayed(
      const Duration(seconds: 2),
    );
    if (!isRegisterSingleton) {
      await start(isInit: false);
    }

    sSignalRModules.setInitFinished(true);
  }

  Future<void> simulateError() async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.warning,
          place: 'SignalRService',
          message: 'simulateError',
        );

    try {
      await getIt
          .get<SignalRModuleNew>(
            instanceName: signalRSingletinName,
          )
          .simulateError();
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'SignalRService',
            message: 'Force Reconnect Error 2: $e',
          );
    }
  }

  Future<void> killSignalR() async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.warning,
          place: 'SignalRService',
          message: 'Kill SignalR',
        );

    try {
      if (getIt.isRegistered<SignalRModuleNew>(instanceName: signalRSingletinName)) {
        isRegisterSingleton = false;
        await getIt.unregister<SignalRModuleNew>(
          instanceName: signalRSingletinName,
          disposingFunction: (p0) {
            p0.dispose();
          },
        );
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'SignalRService',
            message: 'Force Reconnect Error 2: $e',
          );
    }
  }

  Future<void> _getSignalRModule() async {
    sSignalRModules = SignalRServiceUpdated();

    await sSignalRModules.launch();

    /*
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
    */
  }

  Future<SignalRModuleNew> createNewService() async {
    final transport = SignalRTransport(
      initFinished: sSignalRModules.setInitFinished,
      cards: sSignalRModules.setCards,
      cardLimits: sSignalRModules.setCardLimitModel,
      operationHistory: sSignalRModules.operationHistoryEvent,
      kycCountries: sSignalRModules.setKYCCountries,
      marketInfo: sSignalRModules.setMarketInfo,
      marketCampaigns: sSignalRModules.setMarketCampaigns,
      referralStats: sSignalRModules.setReferralStats,
      marketItems: sSignalRModules.setMarketItems,
      periodPrices: sSignalRModules.setPeriodPrices,
      clientDetail: sSignalRModules.setClientDetail,
      keyValue: sSignalRModules.setKeyValue,
      indicesDetails: sSignalRModules.setIndicesDetails,
      priceAccuracies: sSignalRModules.setPriceAccuracies,
      referralInfo: sSignalRModules.setReferralInfo,
      fireblockEventAction: sSignalRModules.fireblockEventAction,
      setAssets: sSignalRModules.setAssets,
      updateBalances: sSignalRModules.updateBalances,
      updateBlockchains: sSignalRModules.updateBlockchains,
      updateBasePrices: sSignalRModules.updateBasePrices,
      updateAssetsWithdrawalFees: sSignalRModules.updateAssetsWithdrawalFees,
      updateAssetPaymentMethodsNew: sSignalRModules.updateAssetPaymentMethodsNew,
      receiveGifts: sSignalRModules.reciveGiftsEvent,
      rewardsProfile: sSignalRModules.rewardsProfileMethods,
      bankingProfile: sSignalRModules.setBankingProfileData,
      setPendingOperationCount: sSignalRModules.setPendingOperationCount,
      investPositions: sSignalRModules.setInvestPositionsData,
      investInstruments: sSignalRModules.setInvestInstrumentsData,
      investPrices: sSignalRModules.setInvestPricesData,
      investSectors: sSignalRModules.setInvestSectorsData,
      investWallet: sSignalRModules.setInvestWalletData,
      investBaseDailyPrice: sSignalRModules.setInvestBaseDailyPriceData,
      earnOffers: sSignalRModules.setEarnOffersData,
      activeEarnPositions: sSignalRModules.setEarnPositionsData,
      banersListMessage: sSignalRModules.setBanersListData,
      smplWalletModel: sSignalRModules.setSmplWalletModelData,
      marketSectorsMessage: sSignalRModules.setMarketSectorsModelData,

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

          sSignalRModules.signalRLogs.last = sSignalRModules.signalRLogs.last.copyWith(
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

          sSignalRModules.signalRLogs.last = sSignalRModules.signalRLogs.last.copyWith(
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

          sSignalRModules.signalRLogs.last = sSignalRModules.signalRLogs.last.copyWith(
            logs: temp,
          );
        }
      },
      updateGlobalSendMethods: sSignalRModules.setGlobalSendMethods,
    );

    _logger.log(
      level: Level.info,
      place: _loggerValue,
      message: '''CREATE SIGNALR MODULE\nToken: ${getIt.get<AppStore>().authState.token}\n''',
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
      getUrlForConnectin: () {
        final url = getIt.get<SignalRConecrionUrlService>().getUrl();
        return url;
      },
    );
  }
}

Future<String> _getToken() async {
  return getIt.get<AppStore>().authState.token;
}
