import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_withdrawal_fee_model.dart';
import 'package:simple_networking/modules/signal_r/models/balance_model.dart';
import 'package:simple_networking/modules/signal_r/models/baner_model.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/base_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/signal_r/models/campaign_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/signal_r/models/cards_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';
import 'package:simple_networking/modules/signal_r/models/fireblock_events_model.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/signal_r/models/indices_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_base_daily_price_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/key_value_model.dart';
import 'package:simple_networking/modules/signal_r/models/kyc_countries_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_references_model.dart';
import 'package:simple_networking/modules/signal_r/models/period_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/price_accuracies.dart';
import 'package:simple_networking/modules/signal_r/models/referral_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_stats_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/rewards_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/smpl_wallet_model.dart';

import 'models/incoming_gift_model.dart';
import 'models/invest_positions_model.dart';
import 'models/invest_prices_model.dart';
import 'models/invest_sectors_model.dart';
import 'models/invest_wallet_model.dart';

class SignalRTransport {
  SignalRTransport({
    required this.initFinished,
    required this.cards,
    required this.cardLimits,
    required this.operationHistory,
    required this.kycCountries,
    required this.marketInfo,
    required this.marketCampaigns,
    required this.referralStats,
    required this.marketItems,
    required this.periodPrices,
    required this.clientDetail,
    required this.keyValue,
    required this.indicesDetails,
    required this.priceAccuracies,
    required this.referralInfo,
    required this.fireblockEventAction,
    required this.setAssets,
    required this.updateBalances,
    required this.updateBlockchains,
    required this.updateBasePrices,
    required this.updateAssetsWithdrawalFees,
    required this.updateAssetPaymentMethodsNew,
    required this.createNewSessionLog,
    required this.addToPing,
    required this.addToPong,
    required this.addToLog,
    required this.updateGlobalSendMethods,
    required this.receiveGifts,
    required this.rewardsProfile,
    required this.bankingProfile,
    required this.setPendingOperationCount,
    required this.investPositions,
    required this.investInstruments,
    required this.investPrices,
    required this.investSectors,
    required this.investWallet,
    required this.investBaseDailyPrice,
    required this.earnOffers,
    required this.activeEarnPositions,
    required this.banersListMessage,
    required this.smplWalletModel,
  });

  final void Function(bool) initFinished;
  final void Function(CardsModel) cards;
  final void Function(CardLimitsModel) cardLimits;
  final void Function(String) operationHistory;

  final void Function(KycCountriesResponseModel) kycCountries;
  final void Function(TotalMarketInfoModel) marketInfo;
  final void Function(CampaignResponseModel) marketCampaigns;
  final void Function(ReferralStatsResponseModel) referralStats;

  final void Function(MarketReferencesModel) marketItems;
  final void Function(PeriodPricesModel) periodPrices;
  final void Function(ClientDetailModel) clientDetail;
  final void Function(KeyValueModel) keyValue;
  final void Function(IndicesModel) indicesDetails;
  final void Function(PriceAccuracies) priceAccuracies;

  final void Function(ReferralInfoModel) referralInfo;
  final void Function(FireblockEventsModel) fireblockEventAction;

  final void Function(AssetsModel) setAssets;
  final void Function(BalancesModel) updateBalances;
  final void Function(BlockchainsModel) updateBlockchains;
  final void Function(BasePricesModel) updateBasePrices;
  final void Function(AssetWithdrawalFeeModel) updateAssetsWithdrawalFees;
  final void Function(AssetPaymentMethodsNew) updateAssetPaymentMethodsNew;

  final void Function(GlobalSendMethodsModel) updateGlobalSendMethods;

  final void Function(IncomingGiftModel) receiveGifts;
  final void Function(RewardsProfileModel) rewardsProfile;

  final void Function(BankingProfileModel) bankingProfile;

  final void Function(int) setPendingOperationCount;

  final void Function(InvestPositionsModel) investPositions;
  final void Function(InvestInstrumentsModel) investInstruments;
  final void Function(InvestPricesModel) investPrices;
  final void Function(InvestSectorsModel) investSectors;
  final void Function(InvestWalletModel) investWallet;
  final void Function(InvestBaseDailyPriceModel) investBaseDailyPrice;

  final void Function(ActiveEarnOffersMessage) earnOffers;
  final void Function(ActiveEarnPositionsMessage) activeEarnPositions;

  final void Function(BanersListMessage) banersListMessage;

  final void Function(SmplWalletModel) smplWalletModel;

  /// Logs

  final void Function() createNewSessionLog;
  final void Function(DateTime) addToPing;
  final void Function(DateTime) addToPong;
  final void Function(DateTime, String) addToLog;
}
