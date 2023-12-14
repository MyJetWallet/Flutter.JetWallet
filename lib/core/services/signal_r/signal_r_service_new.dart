import 'dart:async';

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:isolator/isolator.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/signal_r/helpers/market_references.dart';
import 'package:jetwallet/core/services/signal_r/signalr_backend.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_country_model.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/market_details/helper/calculate_percent_change.dart';
import 'package:jetwallet/features/market/market_details/model/return_rates_model.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/store/search_store.dart';
import 'package:jetwallet/features/receive_gift/receive_gift_bottom_sheet.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/helpers/set_category_for_buy_methods.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
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
import 'package:simple_networking/modules/signal_r/models/incoming_gift_model.dart';
import 'package:simple_networking/modules/signal_r/models/indices_model.dart';
import 'package:simple_networking/modules/signal_r/models/key_value_model.dart';
import 'package:simple_networking/modules/signal_r/models/kyc_countries_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_references_model.dart';
import 'package:simple_networking/modules/signal_r/models/period_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/price_accuracies.dart';
import 'package:simple_networking/modules/signal_r/models/referral_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_stats_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/rewards_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/signalr_log.dart';

import '../../../features/account/profile_details/store/change_base_asset_store.dart';

part 'signal_r_service_new.g.dart';

late SignalRServiceUpdated sSignalRModules;

class SignalRServiceUpdated extends _SignalRServiceUpdatedBase with _$SignalRServiceUpdated {
  SignalRServiceUpdated() : super();
}

abstract class _SignalRServiceUpdatedBase with Frontend, Store {
  Future<void> launch() async {
    //await initBackend(initializer: _launch);

    //await run(event: SignalREvents.setIconsApi, data: iconApi);
  }

  // Isolates
  static SignalRBackEnd _launch(BackendArgument<void> argument) {
    return SignalRBackEnd(
      argument: argument,
    );
  }

  @override
  void initActions() {
    whenEventCome(SignalREvents.getCurrencyModelsData).run(getCurrencyDataFunc);
    whenEventCome(SignalREvents.getCurrenciesWithHiddenListModelsData).run(getCurrenciesWithHiddenListDataFunc);

    whenEventCome(SignalREvents.updateAssetsWithdrawalFeesData).run(updateAssetsWithdrawalFeesData);
    whenEventCome(SignalREvents.updateAssetPaymentMethodsNewData).run(updateAssetPaymentMethodsNewData);
    whenEventCome(SignalREvents.updateBalancesData).run(updateBalancesData);

    whenEventCome(SignalREvents.updateBasePricesCurrenciesListData).run(updateBasePricesData);
    whenEventCome(SignalREvents.updateBasePricesHiddenCurrenciesListData).run(updateBasePricesHiddenListData);

    whenEventCome(SignalREvents.updateBlockchainsData).run(updateBlockchainsData);
  }

  @observable
  ObservableList<SignalrLog> signalRLogs = ObservableList.of([]);

  @observable
  BaseCurrencyModel baseCurrency = const BaseCurrencyModel();
  @action
  void setBaseCurrency(BaseCurrencyModel value) {
    baseCurrency = value;

    //run(event: SignalREvents.setBaseCurrency, data: value);
  }

  @action
  void updateBaseCurrency() {
    final elements = currenciesWithHiddenList.where(
      (element) => element.symbol == clientDetail.baseAssetSymbol,
    );

    baseCurrency = BaseCurrencyModel(
      prefix: elements.isEmpty ? null : elements.first.prefixSymbol,
      symbol: clientDetail.baseAssetSymbol,
      accuracy: elements.isEmpty ? 0 : elements.first.accuracy,
    );

    //run(event: SignalREvents.setBaseCurrency, data: baseCurrency);
  }

  @observable
  bool initFinished = false;
  @action
  void setInitFinished(bool value) {
    initFinished = value;
    getIt.get<ChangeBaseAssetStore>().finishLoading();
  }

  @observable
  CardsModel cards = const CardsModel(now: 0, cardInfos: []);
  @action
  void setCards(CardsModel value) => cards = value;

  @observable
  CardLimitsModel? cardLimitsModel;
  @action
  void setCardLimitModel(CardLimitsModel value) => cardLimitsModel = value;

  @observable
  GlobalSendMethodsModel? globalSendMethods;
  @action
  void setGlobalSendMethods(GlobalSendMethodsModel value) => globalSendMethods = value;

  @observable
  ObservableList<KycCountryModel> kycCountries = ObservableList.of([]);
  @action
  void setKYCCountries(KycCountriesResponseModel data) {
    final value = <KycCountryModel>[];

    final kycCountriesList = data.countries.toList();

    if (kycCountriesList.isNotEmpty) {
      for (var i = 0; i < kycCountriesList.length; i++) {
        final documents = <KycDocumentType>[];

        final acceptedDocuments = kycCountriesList[i].acceptedDocuments.toList();

        if (acceptedDocuments.isNotEmpty) {
          acceptedDocuments.sort(
            (a, b) => a.compareTo(b),
          );

          for (final document in acceptedDocuments) {
            documents.add(kycDocumentType(document));
          }
        }

        final obj = KycCountryModel(
          countryCode: kycCountriesList[i].countryCode,
          countryName: kycCountriesList[i].countryName,
          acceptedDocuments: documents,
          isBlocked: kycCountriesList[i].isBlocked,
        );

        if (!value.contains(obj)) {
          value.add(
            obj,
          );
        }
      }
    }

    kycCountries = ObservableList.of(value);
  }

  @observable
  Decimal marketInfo = Decimal.zero;
  @action
  void setMarketInfo(TotalMarketInfoModel value) => marketInfo = value.marketCapChange24H.round(scale: 2);

  @observable
  ObservableList<CampaignModel> marketCampaigns = ObservableList.of([]);
  @action
  void setMarketCampaigns(CampaignResponseModel value) => marketCampaigns = ObservableList.of(value.campaigns);

  @observable
  ObservableList<ReferralStatsModel> referralStats = ObservableList.of([]);
  @action
  void setReferralStats(ReferralStatsResponseModel value) => referralStats = ObservableList.of(value.referralStats);

  @observable
  ObservableList<MarketItemModel> marketItems = ObservableList.of([]);
  @observable
  MarketReferencesModel? marketReferencesModel;
  @action
  void setMarketItems(MarketReferencesModel value) {
    marketReferencesModel = value;
    marketItems.clear();

    final items = <MarketItemModel>[];

    for (final marketReference in value.references) {
      late CurrencyModel currency;

      try {
        currency = currenciesList.firstWhere(
          (element) {
            return element.symbol == marketReference.associateAsset;
          },
        );
      } catch (_) {
        continue;
      }

      if (currency.symbol != baseCurrency.symbol) {
        items.add(
          MarketItemModel(
            iconUrl: iconUrlFrom(assetSymbol: currency.symbol),
            weight: marketReference.weight,
            associateAsset: marketReference.associateAsset,
            associateAssetPair: marketReference.associateAssetPair,
            symbol: currency.symbol,
            name: currency.description,
            dayPriceChange: currency.dayPriceChange,
            dayPercentChange: currency.dayPercentChange,
            lastPrice: currency.currentPrice,
            assetBalance: currency.assetBalance,
            baseBalance: currency.baseBalance,
            prefixSymbol: currency.prefixSymbol,
            assetAccuracy: currency.accuracy,
            priceAccuracy: marketReference.priceAccuracy,
            startMarketTime: marketReference.startMarketTime,
            type: currency.type,
          ),
        );
      }
    }

    marketItems = ObservableList.of(
      _formattedItems(
        items,
        getIt.get<SearchStore>().search,
      ),
    );
  }

  @observable
  ClientDetailModel clientDetail = ClientDetailModel(
    baseAssetSymbol: 'USD',
    walletCreationDate: DateTime.now().toString(),
    recivedAt: DateTime.now(),
  );
  @action
  void setClientDetail(ClientDetailModel value) {
    clientDetail = value;

    for (var i = 0; i < clientDetail.clientBlockers.length; i++) {
      clientDetail.clientBlockers[i] = clientDetail.clientBlockers[i].copyWith(
        expireDateTime: DateTime.now().add(
          getDurationFromBlocker(clientDetail.clientBlockers[i].timespanToExpire),
        ),
      );
    }

    updateBaseCurrency();
    updateAnalyticsKYCStatus();
  }

  @action
  void updateAnalyticsKYCStatus() {
    final kyc = getIt.get<KycService>();

    var analyticsKyc = 0;
    if (checkKycPassed(kyc.depositStatus, kyc.tradeStatus, kyc.withdrawalStatus)) {
      analyticsKyc = 2;
    }
    if (kycInProgress(kyc.depositStatus, kyc.tradeStatus, kyc.withdrawalStatus)) {
      analyticsKyc = 1;
    }
    if (checkKycBlocked(kyc.depositStatus, kyc.tradeStatus, kyc.withdrawalStatus)) {
      analyticsKyc = 4;
    }
    sAnalytics.setKYCDepositStatus = analyticsKyc;
  }

  @observable
  KeyValueModel keyValue = const KeyValueModel(
    now: 0,
    keys: [],
  );
  @action
  void setKeyValue(KeyValueModel value) {
    keyValue = value;
  }

  @observable
  ObservableList<IndexModel> indicesDetails = ObservableList.of([]);
  @action
  void setIndicesDetails(IndicesModel value) => indicesDetails = ObservableList.of(value.indices);

  @observable
  ObservableList<PriceAccuracy> priceAccuracies = ObservableList.of([]);
  @action
  void setPriceAccuracies(PriceAccuracies value) => priceAccuracies = ObservableList.of(value.accuracies);

  @observable
  ReferralInfoModel referralInfo = const ReferralInfoModel(
    descriptionLink: '',
    referralLink: '',
    title: '',
    referralTerms: [],
    referralCode: '',
  );
  @action
  void setReferralInfo(ReferralInfoModel value) => referralInfo = value;

  @action
  void fireblockEventAction(FireblockEventsModel value) {
    if (value.events != null) {
      for (final event in value.events!) {
        final messageType = event.eventType == 'Kyc'
            ? 'kyc_successful'
            : event.eventType == 'FirstTimeBuy'
                ? 'first_time_buy'
                : event.eventType ?? '';

        FirebaseAnalytics.instance.logEvent(
          name: messageType,
        );

        sNetwork.getWalletModule().postProfileReport(
              event.messageId ?? '',
            );
      }
    }
  }

  ///

  @observable
  ObservableList<CurrencyModel> currenciesList = ObservableList.of([]);
  @observable
  ObservableList<CurrencyModel> currenciesWithHiddenList = ObservableList.of([]);

  @action
  Future<void> setAssets(AssetsModel value) async {
    currenciesList.clear();
    currenciesWithHiddenList.clear();

    //await run(event: SignalREvents.setAssets, data: value);
    //await run(event: SignalREvents.getCurrencyModels, data: value);
    //await run(event: SignalREvents.getCurrenciesWithHiddenListModels, data: value);

    for (final asset in value.assets) {
      if (!asset.hideInTerminal) {
        final depositBlockchains =
            asset.depositBlockchains.map((blockchain) => BlockchainModel(id: blockchain)).toList();

        final withdrawalBlockchains =
            asset.withdrawalBlockchains.map((blockchain) => BlockchainModel(id: blockchain)).toList();

        // TODO(yaroslav): crearet fromAssetModel factory method
        final currModel = CurrencyModel(
          symbol: asset.symbol,
          description: asset.description,
          accuracy: asset.accuracy.toInt(),
          normalizedAccuracy: asset.normalizedAccuracy.toInt(),
          tagType: asset.tagType,
          type: asset.type,
          fees: asset.fees,
          depositBlockchains: depositBlockchains,
          withdrawalBlockchains: withdrawalBlockchains,
          iconUrl: iconUrlFrom(
            assetSymbol: asset.symbol,
          ),
          selectedIndexIconUrl: iconUrlFrom(
            assetSymbol: asset.symbol,
            selected: true,
          ),
          weight: asset.weight,
          prefixSymbol: asset.prefixSymbol,
          apy: Decimal.zero,
          apr: Decimal.zero,
          assetBalance: Decimal.zero,
          assetCurrentEarnAmount: Decimal.zero,
          assetTotalEarnAmount: Decimal.zero,
          cardReserve: Decimal.zero,
          baseBalance: Decimal.zero,
          baseCurrentEarnAmount: Decimal.zero,
          baseTotalEarnAmount: Decimal.zero,
          currentPrice: Decimal.zero,
          dayPriceChange: Decimal.zero,
          earnProgramEnabled: asset.earnProgramEnabled,
          depositInProcess: Decimal.zero,
          earnInProcessTotal: Decimal.zero,
          buysInProcessTotal: Decimal.zero,
          transfersInProcessTotal: Decimal.zero,
          earnInProcessCount: 0,
          buysInProcessCount: 0,
          transfersInProcessCount: 0,
          minTradeAmount: asset.minTradeAmount,
          maxTradeAmount: asset.maxTradeAmount,
          walletIsActive: asset.walletIsActive ?? false,
          walletOrder: asset.walletOrder,
        );

        if (!currenciesList.any((currency) => currency.symbol == currModel.symbol)) {
          currenciesList.add(currModel);
        }
      }

      currenciesWithHiddenList.add(
        CurrencyModel(
          symbol: asset.symbol,
          description: asset.description,
          accuracy: asset.accuracy.toInt(),
          normalizedAccuracy: asset.normalizedAccuracy.toInt(),
          tagType: asset.tagType,
          type: asset.type,
          fees: asset.fees,
          iconUrl: iconUrlFrom(
            assetSymbol: asset.symbol,
          ),
          selectedIndexIconUrl: iconUrlFrom(
            assetSymbol: asset.symbol,
            selected: true,
          ),
          weight: asset.weight,
          prefixSymbol: asset.prefixSymbol,
          apy: Decimal.zero,
          apr: Decimal.zero,
          assetBalance: Decimal.zero,
          assetCurrentEarnAmount: Decimal.zero,
          assetTotalEarnAmount: Decimal.zero,
          cardReserve: Decimal.zero,
          baseBalance: Decimal.zero,
          baseCurrentEarnAmount: Decimal.zero,
          baseTotalEarnAmount: Decimal.zero,
          currentPrice: Decimal.zero,
          dayPriceChange: Decimal.zero,
          earnProgramEnabled: asset.earnProgramEnabled,
          depositInProcess: Decimal.zero,
          earnInProcessTotal: Decimal.zero,
          buysInProcessTotal: Decimal.zero,
          transfersInProcessTotal: Decimal.zero,
          earnInProcessCount: 0,
          buysInProcessCount: 0,
          transfersInProcessCount: 0,
          minTradeAmount: asset.minTradeAmount,
          maxTradeAmount: asset.maxTradeAmount,
          walletIsActive: asset.walletIsActive ?? false,
          walletOrder: asset.walletOrder,
        ),
      );
    }

    if (assetsWithdrawalFees != null) {
      updateAssetsWithdrawalFees(assetsWithdrawalFees!);
    }

    if (assetPaymentMethodsNew != null) {
      updateAssetPaymentMethodsNew(assetPaymentMethodsNew!);
    }

    if (balancesModel != null) {
      updateBalances(balancesModel!);
    }

    if (basePricesModel != null) {
      await updateBasePrices(basePricesModel!);
    }

    if (blockchainsModel != null) {
      updateBlockchains(blockchainsModel!);
    }

    if (currenciesList.isNotEmpty) {
      updateBaseCurrency();
    }
  }

  @action
  void getCurrencyDataFunc({required SignalREvents event, required List<CurrencyModel> data}) {
    currenciesList = ObservableList.of(data);

    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: 'getCurrencyDataFunc',
          message: '${data.length}',
        );
  }

  @action
  void getCurrenciesWithHiddenListDataFunc({required SignalREvents event, required List<CurrencyModel> data}) {
    currenciesWithHiddenList = ObservableList.of(data);
  }

  BalancesModel? balancesModel;
  void updateBalances(BalancesModel value) {
    balancesModel = value;

    //run(event: SignalREvents.updateBalances, data: value);

    if (currenciesList.isNotEmpty) {
      for (final balance in value.balances) {
        final currency = currenciesList.firstWhereOrNull((c) => c.symbol == balance.assetId);

        if (currency != null) {
          final index = currenciesList.indexOf(currency);

          currenciesList[index] = currency.copyWith(
            lastUpdate: balance.lastUpdate,
            assetBalance: currency.symbol == 'EUR' ? totalEurWalletBalance : balance.balance,
            assetTotalEarnAmount: balance.totalEarnAmount,
            assetCurrentEarnAmount: balance.currentEarnAmount,
            cardReserve: balance.cardReserve,
            nextPaymentDate: balance.nextPaymentDate,
            apy: balance.apy,
            apr: balance.apr,
            depositInProcess: balance.depositInProcess,
            earnInProcessTotal: balance.earnInProcessTotal,
            buysInProcessTotal: balance.buysInProcessTotal,
            transfersInProcessTotal: balance.transfersInProcessTotal,
            earnInProcessCount: balance.earnInProcessCount,
            buysInProcessCount: balance.buysInProcessCount,
            transfersInProcessCount: balance.transfersInProcessCount,
          );
        }
      }
    }

    //getIt.get<ChangeBaseAssetStore>().finishLoading();
  }

  @action
  void updateBalancesData({required SignalREvents event, required List<CurrencyModel> data}) {
    currenciesList = ObservableList.of(data);

    //log(data.where((element) => element.symbol == 'EUR').first.assetBalance.toJson());

    getIt.get<ChangeBaseAssetStore>().finishLoading();
  }

  @observable
  BlockchainsModel? blockchainsModel;
  @action
  void updateBlockchains(BlockchainsModel data) {
    blockchainsModel = data;

    //run(event: SignalREvents.updateBlockchains, data: data);

    if (currenciesList.isNotEmpty) {
      for (final currency in currenciesList) {
        final index = currenciesList.indexOf(currency);

        if (currenciesList[index].depositBlockchains.isNotEmpty) {
          for (final depositBlockchain in currenciesList[index].depositBlockchains) {
            final blockchainIndex = currenciesList[index].depositBlockchains.indexOf(depositBlockchain);
            for (final blockchain in data.blockchains) {
              if (depositBlockchain.id == blockchain.id) {
                currenciesList[index].depositBlockchains[blockchainIndex] =
                    currenciesList[index].depositBlockchains[blockchainIndex].copyWith(
                          tagType: blockchain.tagType,
                          description: blockchain.description,
                          blockchainExplorerUrlTemplate: blockchain.blockchainExplorerUrlTemplate,
                        );
              }
            }
          }
        }

        if (currenciesList[index].withdrawalBlockchains.isNotEmpty) {
          for (final withdrawalBlockchain in currenciesList[index].withdrawalBlockchains) {
            final blockchainIndex = currenciesList[index].withdrawalBlockchains.indexOf(withdrawalBlockchain);
            for (final blockchain in data.blockchains) {
              if (withdrawalBlockchain.id == blockchain.id) {
                currenciesList[index].withdrawalBlockchains[blockchainIndex] =
                    currenciesList[index].withdrawalBlockchains[blockchainIndex].copyWith(
                          tagType: blockchain.tagType,
                          description: blockchain.description,
                          blockchainExplorerUrlTemplate: blockchain.blockchainExplorerUrlTemplate,
                        );
              }
            }
          }
        }
      }
    }
  }

  @action
  void updateBasePricesData({required SignalREvents event, required List<CurrencyModel> data}) {
    currenciesList = ObservableList.of(data);
  }

  @action
  void updateBasePricesHiddenListData({required SignalREvents event, required List<CurrencyModel> data}) {
    currenciesWithHiddenList = ObservableList.of(data);
  }

  @action
  void updateBlockchainsData({required SignalREvents event, required List<CurrencyModel> data}) {
    currenciesList = ObservableList.of(data);
  }

  @observable
  BasePricesModel? basePricesModel;
  @action
  Future<void> updateBasePrices(BasePricesModel value) async {
    basePricesModel = value;

    //await run(event: SignalREvents.updateBasePricesCurrenciesList, data: value);
    //await run(event: SignalREvents.updateBasePricesHiddenCurrenciesList, data: value);

    if (currenciesList.isNotEmpty) {
      for (final currency in currenciesList) {
        final index = currenciesList.indexOf(currency);

        final assetPrice = basePriceFrom(
          prices: value.prices,
          assetSymbol: currency.symbol,
        );

        //TODO: assetBalance: totalEurWalletBalance,
        final baseBalance = currency.symbol == 'EUR'
            ? calculateBaseBalance(
                assetSymbol: currency.symbol,
                assetBalance: totalEurWalletBalance,
                assetPrice: assetPrice,
                baseCurrencySymbol: baseCurrency.symbol,
              )
            : calculateBaseBalance(
                assetSymbol: currency.symbol,
                assetBalance: currency.assetBalance,
                assetPrice: assetPrice,
                baseCurrencySymbol: baseCurrency.symbol,
              );

        if (assetPrice.currentPrice != Decimal.zero) {
          currenciesList[index] = currency.copyWith(
            baseBalance: baseBalance,
            currentPrice: assetPrice.currentPrice,
            dayPriceChange: assetPrice.dayPriceChange,
            dayPercentChange: assetPrice.dayPercentChange,
            baseTotalEarnAmount: Decimal.zero,
            baseCurrentEarnAmount: Decimal.zero,
          );
        }
      }
    }

    if (currenciesWithHiddenList.isNotEmpty) {
      for (final currency in currenciesWithHiddenList) {
        final index = currenciesWithHiddenList.indexOf(currency);

        final assetPrice = basePriceFrom(
          prices: value.prices,
          assetSymbol: currency.symbol,
        );

        final baseBalance = calculateBaseBalance(
          assetSymbol: currency.symbol,
          assetBalance: currency.assetBalance,
          assetPrice: assetPrice,
          baseCurrencySymbol: baseCurrency.symbol,
        );

        final baseTotalEarnAmount = calculateBaseBalance(
          assetSymbol: currency.symbol,
          assetBalance: currency.assetTotalEarnAmount,
          assetPrice: assetPrice,
          baseCurrencySymbol: baseCurrency.symbol,
        );

        final baseCurrentEarnAmount = calculateBaseBalance(
          assetSymbol: currency.symbol,
          assetBalance: currency.assetCurrentEarnAmount,
          assetPrice: assetPrice,
          baseCurrencySymbol: baseCurrency.symbol,
        );

        currenciesWithHiddenList[index] = currency.copyWith(
          baseBalance: baseBalance,
          currentPrice: assetPrice.currentPrice,
          dayPriceChange: assetPrice.dayPriceChange,
          dayPercentChange: assetPrice.dayPercentChange,
          baseTotalEarnAmount: baseTotalEarnAmount,
          baseCurrentEarnAmount: baseCurrentEarnAmount,
        );
      }
    }
  }

  AssetWithdrawalFeeModel? assetsWithdrawalFees;
  void updateAssetsWithdrawalFees(AssetWithdrawalFeeModel value) {
    assetsWithdrawalFees = value;

    //run(event: SignalREvents.updateAssetsWithdrawalFees, data: value);

    if (currenciesList.isNotEmpty) {
      for (final assetFee in value.assetFees) {
        final currency = currenciesList.firstWhereOrNull((c) => c.symbol == assetFee.asset);

        if (currency != null) {
          final index = currenciesList.indexOf(currency);
          final assetWithdrawalFees = List.of(currency.assetWithdrawalFees)..add(assetFee);

          currenciesList[index] = currency.copyWith(assetWithdrawalFees: assetWithdrawalFees);
        }
      }
    }
  }

  @action
  void updateAssetsWithdrawalFeesData({required SignalREvents event, required List<CurrencyModel> data}) {
    currenciesList = ObservableList.of(data);
  }

  @action
  void updateAssetPaymentMethodsNewData({required SignalREvents event, required List<CurrencyModel> data}) {
    currenciesList = ObservableList.of(data);
  }

  @observable
  RewardsProfileModel? rewardsData;
  @action
  void rewardsProfileMethods(RewardsProfileModel data) => rewardsData = data;

  @observable
  Decimal totalEurWalletBalance = Decimal.zero;

  @observable
  BankingProfileModel? bankingProfileData;
  @action
  void setBankingProfileData(BankingProfileModel data) {
    /*bankingProfileData = BankingProfileModel(
      showState: BankingShowState.getAccount,
      simple: SimpleBankingModel(
        status: SimpleAccountStatus.allowed,
        account: SimpleBankingAccount(
          label: 'asdasd',
          balance: Decimal.ten,
          status: AccountStatus.active,
        ),
      ),
      banking: BankingDataModel(
        status: BankingClientStatus.allowed,
        accounts: [
          /*
          SimpleBankingAccount(
            label: 'asdasd',
            balance: Decimal.ten,
            status: AccountStatus.inCreation,
          ),
          */
        ],
      ),
    );
    */

    bankingProfileData = data;

    totalEurWalletBalance = Decimal.zero;

    totalEurWalletBalance +=
        (data.banking?.accounts ?? []).fold(Decimal.zero, (sum, el) => sum + (el.balance ?? Decimal.zero));

    totalEurWalletBalance += data.simple?.account?.balance ?? Decimal.zero;

    if (basePricesModel != null) {
      updateBasePrices(basePricesModel!);
    }
    if (balancesModel != null) {
      updateBalances(balancesModel!);
    }
  }

  @observable
  int pendingOperationCount = 0;
  @action
  void setPendingOperationCount(int count) => pendingOperationCount = count;

  @observable
  bool showPaymentsMethods = false;
  @observable
  AssetPaymentMethods? assetPaymentMethods;
  @observable
  AssetPaymentMethodsNew? assetPaymentMethodsNew;

  @observable
  ObservableList<AssetPaymentProducts>? assetProducts = ObservableList.of([]);
  @observable
  List<String> paymentMethods = [];

  @observable
  List<SendMethodDto> sendMethods = [];

  @observable
  ObservableList<BuyMethodDto> buyMethods = ObservableList.of([]);

  @observable
  ObservableList<AssetPaymentProducts>? paymentProducts = ObservableList.of([]);

  @action
  void updateAssetPaymentMethodsNew(AssetPaymentMethodsNew value) {
    showPaymentsMethods = value.showCardsInProfile;
    assetPaymentMethodsNew = value;
    buyMethods = ObservableList.of(value.buy ?? []);
    paymentProducts = ObservableList.of(value.product ?? []);
    assetProducts = ObservableList.of(value.product ?? []);
    sendMethods = value.send ?? [];

    //run(event: SignalREvents.updateAssetPaymentMethodsNew, data: value);
    for (final currency in currenciesList) {
      final buyMethods = (value.buy ?? [])
          .where((buyMethod) => buyMethod.allowedForSymbols?.contains(currency.symbol) ?? false)
          .map(setCategoryForBuyMethods)
          .toList();

      final sendMethods = (value.send ?? [])
          .where((sendMethod) =>
              sendMethod.symbolNetworkDetails?.any((element) => element.symbol == currency.symbol) ?? false)
          .toList();

      final receiveMethods = (value.receive ?? [])
          .where((receiveMethod) => receiveMethod.symbols?.contains(currency.symbol) ?? false)
          .toList();

      if (buyMethods.isNotEmpty) {
        buyMethods.sort((a, b) => (a.orderId ?? 0).compareTo(b.orderId ?? 0));
      }

      currenciesList[currenciesList.indexOf(currency)] = currency.copyWith(
        buyMethods: buyMethods,
        withdrawalMethods: sendMethods,
        depositMethods: receiveMethods,
      );
    }

    paymentMethods.clear();

    if (value.buy != null) {
      for (final asset in value.buy!) {
        paymentMethods.add(asset.id.toString());
      }
    }
  }

  @observable
  PeriodPricesModel? periodPrices;
  @action
  void setPeriodPrices(PeriodPricesModel value) => periodPrices = value;

  @action
  ReturnRatesModel? getReturnRates(String assetId) {
    try {
      final periodPrice = periodPrices!.prices.firstWhere(
        (element) => element.assetSymbol == assetId,
      );

      final currency = currenciesList.firstWhere(
        (element) => element.symbol == assetId,
      );

      return ReturnRatesModel(
        dayPrice: calculatePercentOfChange(
          periodPrice.dayPrice.price.toDouble(),
          currency.currentPrice.toDouble(),
        ),
        weekPrice: calculatePercentOfChange(
          periodPrice.weekPrice.price.toDouble(),
          currency.currentPrice.toDouble(),
        ),
        monthPrice: calculatePercentOfChange(
          periodPrice.monthPrice.price.toDouble(),
          currency.currentPrice.toDouble(),
        ),
        threeMonthPrice: calculatePercentOfChange(
          periodPrice.threeMonthPrice.price.toDouble(),
          currency.currentPrice.toDouble(),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  @action
  Future<void> reciveGiftsEvent(IncomingGiftModel gift) async {
    for (final element in gift.gifts) {
      if (!alreadyShownGifts.any((item) => item.id == element.id)) {
        alreadyShownGifts.add(element);
        unawaited(pushReceiveGiftBottomSheet(element));
      }
    }
  }

  void operationHistoryEvent(String operationId) {
    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: 'Signal R serice nev',
          message: 'operationHistoryEvent',
        );

    getIt.get<EventBus>().fire(GetNewHistoryEvent());
  }

  @computed
  List<MarketItemModel> get getMarketPrices => marketReferencesList(
        marketReferencesModel,
        currenciesList,
      );

  @action
  void clearSignalRModule() {
    initFinished = false;
    showPaymentsMethods = false;
    clientDetail = ClientDetailModel(
      baseAssetSymbol: 'USD',
      walletCreationDate: DateTime.now().toString(),
      recivedAt: DateTime.now(),
    );
    baseCurrency = const BaseCurrencyModel();
    signalRLogs = ObservableList.of([]);
    cardLimitsModel = null;
    marketCampaigns = ObservableList.of([]);
    priceAccuracies = ObservableList.of([]);
    referralStats = ObservableList.of([]);
    keyValue = const KeyValueModel(
      now: 0,
      keys: [],
    );
    referralInfo = const ReferralInfoModel(
      descriptionLink: '',
      referralLink: '',
      title: '',
      referralTerms: [],
      referralCode: '',
    );
    cards = const CardsModel(now: 0, cardInfos: []);
    indicesDetails = ObservableList.of([]);
    marketInfo = Decimal.zero;
    periodPrices = null;
    marketItems = ObservableList.of([]);
    kycCountries = ObservableList.of([]);
    currenciesWithHiddenList = ObservableList.of([]);
    balancesModel = null;
    blockchainsModel = null;
    basePricesModel = null;
    assetsWithdrawalFees = null;
    assetPaymentMethods = null;
    assetPaymentMethodsNew = null;
    paymentMethods = ObservableList.of([]);
  }
}

List<MarketItemModel> _formattedItems(
  List<MarketItemModel> items,
  String searchInput,
) {
  items.sort((a, b) => a.weight.compareTo(b.weight));

  return items
      .where(
        (item) => item.symbol.toLowerCase().contains(searchInput) || item.name.toLowerCase().contains(searchInput),
      )
      .toList();
}
