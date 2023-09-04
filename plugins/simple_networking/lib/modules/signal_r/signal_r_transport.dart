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
import 'package:simple_networking/modules/signal_r/models/fireblock_events_model.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/signal_r/models/indices_model.dart';
import 'package:simple_networking/modules/signal_r/models/instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/key_value_model.dart';
import 'package:simple_networking/modules/signal_r/models/kyc_countries_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_references_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_collections.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:simple_networking/modules/signal_r/models/nft_portfolio.dart';
import 'package:simple_networking/modules/signal_r/models/period_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/price_accuracies.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_stats_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

import 'models/incoming_gift_model.dart';

class SignalRTransport {
  SignalRTransport({
    required this.initFinished,
    required this.cards,
    required this.cardLimits,
    required this.earnOffersList,
    required this.earnProfile,
    required this.operationHistory,
    required this.recurringBuys,
    required this.kycCountries,
    required this.marketInfo,
    required this.marketCampaigns,
    required this.referralStats,
    required this.instruments,
    required this.marketItems,
    required this.periodPrices,
    required this.clientDetail,
    required this.keyValue,
    required this.indicesDetails,
    required this.priceAccuracies,
    required this.referralInfo,
    required this.nftList,
    required this.nftMarket,
    required this.userNFTPortfolio,
    required this.updateUserNft,
    required this.fireblockEventAction,
    required this.setAssets,
    required this.updateBalances,
    required this.updateBlockchains,
    required this.updateBasePrices,
    required this.updateAssetsWithdrawalFees,
    required this.updateAssetPaymentMethods,
    required this.updateAssetPaymentMethodsNew,
    required this.createNewSessionLog,
    required this.addToPing,
    required this.addToPong,
    required this.addToLog,
    required this.updateGlobalSendMethods,
    required this.receiveGifts,
  });

  final void Function(bool) initFinished;
  final void Function(CardsModel) cards;
  final void Function(CardLimitsModel) cardLimits;
  final void Function(List<EarnOfferModel>) earnOffersList;
  final void Function(EarnProfileModel) earnProfile;
  final void Function(String) operationHistory;

  final void Function(RecurringBuysResponseModel) recurringBuys;
  final void Function(KycCountriesResponseModel) kycCountries;
  final void Function(TotalMarketInfoModel) marketInfo;
  final void Function(CampaignResponseModel) marketCampaigns;
  final void Function(ReferralStatsResponseModel) referralStats;
  final void Function(InstrumentsModel) instruments;

  final void Function(MarketReferencesModel) marketItems;
  final void Function(PeriodPricesModel) periodPrices;
  final void Function(ClientDetailModel) clientDetail;
  final void Function(KeyValueModel) keyValue;
  final void Function(IndicesModel) indicesDetails;
  final void Function(PriceAccuracies) priceAccuracies;

  final void Function(ReferralInfoModel) referralInfo;
  final void Function(NftCollections) nftList;
  final void Function(NFTMarkets) nftMarket;
  final void Function(NftPortfolio) userNFTPortfolio;
  final void Function(NftPortfolio) updateUserNft;
  final void Function(FireblockEventsModel) fireblockEventAction;

  final void Function(AssetsModel) setAssets;
  final void Function(BalancesModel) updateBalances;
  final void Function(BlockchainsModel) updateBlockchains;
  final void Function(BasePricesModel) updateBasePrices;
  final void Function(AssetWithdrawalFeeModel) updateAssetsWithdrawalFees;
  final void Function(AssetPaymentMethods) updateAssetPaymentMethods;
  final void Function(AssetPaymentMethodsNew) updateAssetPaymentMethodsNew;

  final void Function(GlobalSendMethodsModel) updateGlobalSendMethods;

  final void Function(IncomingGiftModel) receiveGifts;

  /// Logs

  final void Function() createNewSessionLog;
  final void Function(DateTime) addToPing;
  final void Function(DateTime) addToPong;
  final void Function(DateTime, String) addToLog;
}
