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
import 'package:simple_networking/modules/signal_r/signal_r_new.dart';
import 'package:simple_networking/modules/signal_r/signal_r_transport.dart';
import 'package:simple_networking/simple_networking.dart';
import 'package:logger/logger.dart';

class SignalRService {
  //late SignalRModule signalR;
  SignalRModuleNew? signalR;

  final _logger = getIt.get<SimpleLoggerService>();
  final _loggerValue = 'SignalRService';

  /// CreateService and Start Init
  Future<void> start() async {
    await _getSignalRModule();

    signalR = await createNewService();
    await signalR!.init();
  }

  Future<void> reCreateSignalR() async {
    if (signalR != null) {
      await signalR!.disconnect();
    }

    signalR = await createNewService();
    await signalR!.init();
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
    );

    _logger.log(
      level: Level.info,
      place: _loggerValue,
      message:
          'CREATE SIGNALR MODULE\nToken: ${getIt.get<AppStore>().authState.token}\n',
    );

    return SignalRModuleNew(
      options: getIt.get<SNetwork>().simpleOptions,
      headers: {'User-Agent': await getUserAgent()},
      token: getIt.get<AppStore>().authState.token,
      deviceUid: getIt.get<DeviceInfo>().model.deviceUid,
      localeName: intl.localeName,
      refreshToken: refreshToken,
      transport: transport,
      log: _logger.log,
    );
  }
}
