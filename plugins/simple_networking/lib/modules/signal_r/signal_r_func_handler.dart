import 'dart:developer';

import 'package:simple_networking/config/constants.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/asset_withdrawal_fee_model.dart';
import 'package:simple_networking/modules/signal_r/models/balance_model.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/base_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/signal_r/models/campaign_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/signal_r/models/cards_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/signal_r/models/fireblock_events_model.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/signal_r/models/indices_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/key_value_model.dart';
import 'package:simple_networking/modules/signal_r/models/kyc_countries_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_references_model.dart';
import 'package:simple_networking/modules/signal_r/models/period_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/price_accuracies.dart';
import 'package:simple_networking/modules/signal_r/models/referral_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_stats_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/rewards_profile_model.dart';
import 'package:simple_networking/modules/signal_r/signal_r_new.dart';
import 'package:simple_networking/modules/signal_r/signal_r_transport.dart';

import 'models/incoming_gift_model.dart';
import 'models/invest_sectors_model.dart';
import 'models/invest_wallet_model.dart';

class SignalRFuncHandler {
  SignalRFuncHandler({
    required this.sTransport,
    required this.instance,
  });

  final SignalRTransport sTransport;
  final SignalRModuleNew instance;

  /// This variable is created to track previous snapshot of base prices.
  /// This needed because when signlaR gets update from basePrices it
  /// recevies only prices that changed, this results in overriding prices
  /// that didn't changed with zeros.
  var _oldBasePrices = const BasePricesModel(
    prices: [],
  );

  void initFinishedHandler(List<Object?>? data) {
    try {
      sTransport.initFinished(true);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(cardsMessage, e);
    }
  }

  void cardsMessageHandler(List<Object?>? data) {
    try {
      final cardsList = CardsModel.fromJson(_json(data));
      sTransport.cards(cardsList);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(cardsMessage, e);
    }
  }

  void cardLimitsMessageHandler(List<Object?>? data) {
    try {
      final cardLimits = CardLimitsModel.fromJson(_json(data));
      sTransport.cardLimits(cardLimits);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(cardLimitsMessage, e);
    }
  }

  void kycCountriesMessageHandler(List<Object?>? data) {
    try {
      final countries = KycCountriesResponseModel.fromJson(_json(data));
      sTransport.kycCountries(countries);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(kycCountriesMessage, e);
    }
  }

  void marketInfoMessageHandler(List<Object?>? data) {
    try {
      final model = MarketInfoModel.fromJson(_json(data));
      final info = model.totalMarketInfo;
      sTransport.marketInfo(info);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(kycCountriesMessage, e);
    }
  }

  void campaignsBannersMessageHandler(List<Object?>? data) {
    try {
      final campaigns = CampaignResponseModel.fromJson(_json(data));
      sTransport.marketCampaigns(campaigns);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(campaignsBannersMessage, e);
    }
  }

  void referralStatsMessageHandler(List<Object?>? data) {
    try {
      final referrerStats = ReferralStatsResponseModel.fromList(data!);
      sTransport.referralStats(referrerStats);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(referralStatsMessage, e);
    }
  }

  void assetsMessageHandler(List<Object?>? data) {
    try {
      final assets = AssetsModel.fromJson(_json(data));
      sTransport.setAssets(assets);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(assetsMessage, e);
    }
  }

  void balancesMessageHandler(List<Object?>? data) {
    try {
      final balances = BalancesModel.fromJson(_json(data));
      sTransport.updateBalances(balances);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(balancesMessage, e);
    }
  }

  void blockchainsMessageHandler(List<Object?>? data) {
    try {
      final blockchains = BlockchainsModel.fromJson(_json(data));
      sTransport.updateBlockchains(blockchains);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(blockchainsMessage, e);
    }
  }

  void marketReferenceMessageHandler(List<Object?>? data) {
    try {
      final marketReferences = MarketReferencesModel.fromJson(_json(data));
      sTransport.marketItems(marketReferences);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(marketReferenceMessage, e);
    }
  }

  void basePricesMessageHandler(List<Object?>? data) {
    try {
      _oldBasePrices = BasePricesModel.fromNewPrices(
        json: _json(data),
        oldPrices: _oldBasePrices,
      );
      sTransport.updateBasePrices(_oldBasePrices);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(basePricesMessage, e);
    }
  }

  void periodPricesMessageHandler(List<Object?>? data) {
    try {
      final basePrices = PeriodPricesModel.fromJson(_json(data));
      sTransport.periodPrices(basePrices);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(periodPricesMessage, e);
    }
  }

  void clientDetailMessageHandler(List<Object?>? data) {
    try {
      final map = {
        for (final e in _json(data).entries) e.key: e.value,
        'recivedAt': DateTime.now().toString(),
      };

      final clientDetail = ClientDetailModel.fromJson(map);
      sTransport.clientDetail(clientDetail);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(clientDetailMessage, e);
    }
  }

  void assetWithdrawalFeeMessageHandler(List<Object?>? data) {
    try {
      final assetFees = AssetWithdrawalFeeModel.fromJson(_json(data));
      sTransport.updateAssetsWithdrawalFees(assetFees);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(assetWithdrawalFeeMessage, e);
    }
  }

  void keyValueMessageHandler(List<Object?>? data) {
    try {
      final keyValue = KeyValueModel.parsed(
        KeyValueModel.fromJson(_json(data)),
      );
      sTransport.keyValue(keyValue);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(keyValueMessage, e);
    }
  }

  void indicesMessageHandler(List<Object?>? data) {
    try {
      final indices = IndicesModel.fromJson(_json(data));
      sTransport.indicesDetails(indices);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(indicesMessage, e);
    }
  }

  void convertPriceSettingsMessageHandler(List<Object?>? data) {
    try {
      final settings = PriceAccuracies.fromJson(_json(data));
      sTransport.priceAccuracies(settings);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(convertPriceSettingsMessage, e);
    }
  }

  void paymentMethodsNewMessageHandler(List<Object?>? data) {
    try {
      final info = AssetPaymentMethodsNew.fromJson(_json(data));
      sTransport.updateAssetPaymentMethodsNew(info);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(paymentMethodsNewMessage, e);
    }
  }

  void referralInfoMessageHandler(List<Object?>? data) {
    try {
      final info = ReferralInfoModel.fromJson(_json(data));
      sTransport.referralInfo(info);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(referralInfoMessage, e);
    }
  }

  void fireblocksMessagesHandler(List<Object?>? data) {
    try {
      final fireblockEvents = FireblockEventsModel.fromJson(_json(data));
      sTransport.fireblockEventAction(fireblockEvents);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(fireblocksMessages, e);
    }
  }

  void operationHistoryHandler(List<Object?>? data) {
    try {
      sTransport.operationHistory(_json(data)['operationId'] ?? '');

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(cardsMessage, e);
    }
  }

  void globalSendMethodsHandler(List<Object?>? data) {
    try {
      final globalSendMethods = GlobalSendMethodsModel.fromJson(_json(data));

      sTransport.updateGlobalSendMethods(globalSendMethods);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(cardsMessage, e);
    }
  }

  void incomingGiftsHandler(List<Object?>? data) {
    try {
      final giftModel = IncomingGiftModel.fromJson(_json(data));

      sTransport.receiveGifts(giftModel);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(incomingGiftsMessage, e);
    }
  }

  void rewardsProfileHandler(List<Object?>? data) {
    try {
      final rewardsModel = RewardsProfileModel.fromJson(_json(data));

      sTransport.rewardsProfile(rewardsModel);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(rewardsProfileMessage, e);
    }
  }

  void bankingProfileHandler(List<Object?>? data) {
    try {
      final bankingProfileModel = BankingProfileModel.fromJson(_json(data));

      sTransport.bankingProfile(bankingProfileModel);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(bankingProfileMessage, e);
    }
  }

  void pendingOperationCountHandler(List<Object?>? data) {
    try {
      final int count = _json(data)['count'];

      sTransport.setPendingOperationCount(count);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(bankingProfileMessage, e);
    }
  }

  void investAllActivePositionsMessageHandler(List<Object?>? data) {
    try {

      final investPositionsModel = InvestPositionsModel.fromJson(_json(data));

      sTransport.investPositions(investPositionsModel);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(investAllActivePositionsMessage, e);
    }
  }

  void investInstrumentsMessageHandler(List<Object?>? data) {
    try {

      final investInstrumentsModel = InvestInstrumentsModel.fromJson(_json(data));

      sTransport.investInstruments(investInstrumentsModel);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(investInstrumentsMessage, e);
    }
  }

  void investPricesMessageHandler(List<Object?>? data) {
    try {
      final investPricesModel = InvestPricesModel.fromJson(_json(data));

      sTransport.investPrices(investPricesModel);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(investPricesMessage, e);
    }
  }

  void investSectorsMessageHandler(List<Object?>? data) {
    try {
      final investSectorsModel = InvestSectorsModel.fromJson(_json(data));

      sTransport.investSectors(investSectorsModel);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(investSectorsMessage, e);
    }
  }

  void investWalletMessageHandler(List<Object?>? data) {
    try {
      final investWalletModel = InvestWalletModel.fromJson(_json(data));

      sTransport.investWallet(investWalletModel);

      SignalRModuleNew.handlePackage();
    } catch (e) {
      instance.handleError(investWalletMessage, e);
    }
  }

  /// Type cast response data from the SignalR
  Map<String, dynamic> _json(List<dynamic>? data) {
    return data?.first as Map<String, dynamic>;
  }
}
