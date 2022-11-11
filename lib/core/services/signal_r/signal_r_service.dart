import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_client.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/helpers/get_user_agent.dart';
import 'package:simple_networking/modules/signal_r/signal_r_new.dart';
import 'package:simple_networking/modules/signal_r/signal_r_transport.dart';
import 'package:simple_networking/simple_networking.dart';

class SignalRService {
  //late SignalRModule signalR;
  late SignalRModuleNew signalR;

  /// CreateService and Start Init
  void start() {
    //signalR = createService()..init();

    signalR = createNewService()..init();

    sSignalRModules = getIt.get<SignalRServiceUpdated>();
  }

  SignalRModule createService() {
    return SignalRModule(
      options: getIt.get<SNetwork>().simpleOptions,
      signalRClient: SignalRClient(
        defaultHeaders: {
          'User-Agent': getUserAgent(),
        },
      ),
      token: getIt.get<AppStore>().authState.token,
      deviceUid: getIt.get<DeviceInfo>().model.deviceUid,
      localeName: intl.localeName,
      refreshToken: refreshToken,
    );
  }

  SignalRModuleNew createNewService() {
    final transport = SignalRTransport(
      initFinished: getIt<SignalRServiceUpdated>().setInitFinished,
      cards: getIt<SignalRServiceUpdated>().setCards,
      cardLimits: getIt<SignalRServiceUpdated>().setCardLimitModel,
      earnOffersList: getIt<SignalRServiceUpdated>().setEarnOffersList,
      earnProfile: getIt<SignalRServiceUpdated>().setEarnProfile,
      recurringBuys: getIt<SignalRServiceUpdated>().setRecurringBuys,
      kycCountries: getIt<SignalRServiceUpdated>().setKYCCountries,
      marketInfo: getIt<SignalRServiceUpdated>().setMarketInfo,
      marketCampaigns: getIt<SignalRServiceUpdated>().setMarketCampaigns,
      referralStats: getIt<SignalRServiceUpdated>().setReferralStats,
      instruments: getIt<SignalRServiceUpdated>().setInstruments,
      marketItems: getIt<SignalRServiceUpdated>().setMarketItems,
      periodPrices: getIt<SignalRServiceUpdated>().setPeriodPrices,
      clientDetail: getIt<SignalRServiceUpdated>().setClientDetail,
      keyValue: getIt<SignalRServiceUpdated>().setKeyValue,
      indicesDetails: getIt<SignalRServiceUpdated>().setIndicesDetails,
      priceAccuracies: getIt<SignalRServiceUpdated>().setPriceAccuracies,
      referralInfo: getIt<SignalRServiceUpdated>().setReferralInfo,
      nftList: getIt<SignalRServiceUpdated>().setNFTList,
      nftMarket: getIt<SignalRServiceUpdated>().setNFTMarket,
      userNFTPortfolio: getIt<SignalRServiceUpdated>().setUserNFTPortfolio,
      updateUserNft: getIt<SignalRServiceUpdated>().updateUserNft,
      fireblockEventAction: getIt<SignalRServiceUpdated>().fireblockEventAction,
      setAssets: getIt<SignalRServiceUpdated>().setAssets,
      updateBalances: getIt<SignalRServiceUpdated>().updateBalances,
      updateBlockchains: getIt<SignalRServiceUpdated>().updateBlockchains,
      updateBasePrices: getIt<SignalRServiceUpdated>().updateBasePrices,
      updateAssetsWithdrawalFees:
          getIt<SignalRServiceUpdated>().updateAssetsWithdrawalFees,
      updateAssetPaymentMethods:
          getIt<SignalRServiceUpdated>().updateAssetPaymentMethods,
    );

    return SignalRModuleNew(
      options: getIt.get<SNetwork>().simpleOptions,
      headers: {'User-Agent': getUserAgent()},
      token: getIt.get<AppStore>().authState.token,
      deviceUid: getIt.get<DeviceInfo>().model.deviceUid,
      localeName: intl.localeName,
      refreshToken: refreshToken,
      transport: transport,
    );
  }
}
