import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_with_hidden_service.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/payment_methods_service/payment_methods_service.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_client.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/helpers/get_user_agent.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_withdrawal_fee_model.dart';
import 'package:simple_networking/modules/signal_r/models/balance_model.dart';
import 'package:simple_networking/modules/signal_r/models/base_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/signal_r/models/campaign_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/signal_r/models/cards_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/indices_model.dart';
import 'package:simple_networking/modules/signal_r/models/instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/key_value_model.dart';
import 'package:simple_networking/modules/signal_r/models/kyc_countries_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_references_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_collections.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:simple_networking/modules/signal_r/models/period_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/price_accuracies.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_stats_response_model.dart';
import 'package:simple_networking/simple_networking.dart';

class SignalRService {
  late SignalRModule signalR;

  /// CreateService and Start Init
  void start() {
    signalR = createService()..init();

    getIt.registerSingleton<SignalRModules>(
      SignalRModules(),
    );

    sSignalRModules = getIt.get<SignalRModules>();

    sPaymentMethod.init();
    //sCurrencies.init();
    //sCurrenciesWithHidden.init();
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

  Stream<ClientDetailModel> clientDetail() =>
      signalR.clientDetail().asBroadcastStream();

  Stream<AssetsModel> assets() => signalR.assets().asBroadcastStream();

  Stream<BalancesModel> balances() => signalR.balances().asBroadcastStream();

  Stream<BasePricesModel> basePrices() =>
      signalR.basePrices().asBroadcastStream();

  Stream<AssetPaymentMethods> paymentMethods() =>
      signalR.paymentMethods().asBroadcastStream();

  Stream<BlockchainsModel> blockchains() =>
      signalR.blockchains().asBroadcastStream();

  Stream<RecurringBuysResponseModel> recurringBuy() =>
      signalR.recurringBuy().asBroadcastStream();

  Stream<AssetWithdrawalFeeModel> assetsWithdrawalFees() {
    return signalR.assetWithdrawalFee().asBroadcastStream();
  }

  Stream<KycCountriesResponseModel> kycCountries() => signalR.kycCountries();

  Stream<AssetWithdrawalFeeModel> assetWithdrawalFee() =>
      signalR.assetWithdrawalFee();

  Stream<CardsModel> cards() => signalR.cards().asBroadcastStream();

  Stream<bool> initFinished() => signalR.isAppLoaded().asBroadcastStream();

  Stream<InstrumentsModel> instruments() =>
      signalR.instruments().asBroadcastStream();

  Stream<PeriodPricesModel> periodPrices() =>
      signalR.periodPrices().asBroadcastStream();

  Stream<PriceAccuracies> priceAccuracies() =>
      signalR.priceAccuracies().asBroadcastStream();

  Stream<List<EarnOfferModel>> earnOffers() =>
      signalR.earnOffers().asBroadcastStream();

  Stream<EarnProfileModel> earnProfile() =>
      signalR.earnProfile().asBroadcastStream();

  Stream<CampaignResponseModel> marketCampaigns() =>
      signalR.marketCampaigns().asBroadcastStream();

  Stream<ReferralInfoModel> referralInfo() =>
      signalR.referralInfo().asBroadcastStream();

  Stream<CardLimitsModel> cardLimits() =>
      signalR.cardLimits().asBroadcastStream();

  Stream<ReferralStatsResponseModel> referralStats() =>
      signalR.referralStats().asBroadcastStream();

  Stream<KeyValueModel> keyValue() => signalR.keyValue().asBroadcastStream();

  Stream<MarketReferencesModel> marketReferences() =>
      signalR.marketReferences().asBroadcastStream();

  Stream<IndicesModel> indices() => signalR.indices().asBroadcastStream();

  Stream<TotalMarketInfoModel> marketInfo() =>
      signalR.marketInfo().asBroadcastStream();

  Stream<NftCollections> nftCollections() =>
      signalR.nftCollections().asBroadcastStream();

  Stream<NFTMarkets> nftMarkets() => signalR.nftMarket().asBroadcastStream();
}
