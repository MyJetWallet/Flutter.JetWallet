import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/core/services/signal_r/helpers/converters.dart';
import 'package:jetwallet/core/services/signal_r/helpers/market_references.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/kyc/models/kyc_country_model.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/market_details/helper/calculate_percent_change.dart';
import 'package:jetwallet/features/market/market_details/model/return_rates_model.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/store/search_store.dart';
import 'package:jetwallet/features/receive_gift/receive_gift_bottom_sheet.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/helpers/set_category_for_buy_methods.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
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
import 'package:simple_networking/modules/signal_r/models/incoming_gift_model.dart';
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
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_stats_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/rewards_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/signalr_log.dart';

import '../../../features/account/profile_details/store/change_base_asset_store.dart';

part 'signal_r_service_new.g.dart';

late SignalRServiceUpdated sSignalRModules;

@JsonSerializable()
class SignalRServiceUpdated extends _SignalRServiceUpdatedBase
    with _$SignalRServiceUpdated {
  SignalRServiceUpdated() : super();

  factory SignalRServiceUpdated.fromJson(Map<String, dynamic> json) =>
      _$SignalRServiceUpdatedFromJson(json);

  Map<String, dynamic> toJson() => _$SignalRServiceUpdatedToJson(this);
}

abstract class _SignalRServiceUpdatedBase with Store {
  @observable
  @ObservableSignalRLogsListConverter()
  ObservableList<SignalrLog> signalRLogs = ObservableList.of([]);

  @observable
  BaseCurrencyModel baseCurrency = const BaseCurrencyModel();
  @action
  void setBaseCurrency(BaseCurrencyModel value) => baseCurrency = value;

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
  }

  @observable
  bool initFinished = false;
  @action
  void setInitFinished(bool value) => initFinished = value;

  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  CardsModel cards = const CardsModel(now: 0, cardInfos: []);
  @action
  void setCards(CardsModel value) => cards = value;

  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  CardLimitsModel? cardLimitsModel;
  @action
  void setCardLimitModel(CardLimitsModel value) => cardLimitsModel = value;

  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  GlobalSendMethodsModel? globalSendMethods;
  @action
  void setGlobalSendMethods(GlobalSendMethodsModel value) =>
      globalSendMethods = value;

  @observable
  @ObservableEarnOfferModelListConverter()
  ObservableList<EarnOfferModel> earnOffersList = ObservableList.of([]);
  @action
  void setEarnOffersList(List<EarnOfferModel> value) =>
      earnOffersList = ObservableList.of(value);

  @observable
  EarnProfileModel? earnProfile;
  @action
  void setEarnProfile(EarnProfileModel value) => earnProfile = value;

  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  ObservableList<RecurringBuysModel> recurringBuys = ObservableList.of([]);
  @action
  void setRecurringBuys(RecurringBuysResponseModel value) {
    recurringBuys = ObservableList.of(
      value.recurringBuys,
    );
  }

  @observable
  @ObservableKycCountryModelListConverter()
  ObservableList<KycCountryModel> kycCountries = ObservableList.of([]);
  @action
  void setKYCCountries(KycCountriesResponseModel data) {
    final value = <KycCountryModel>[];

    final kycCountriesList = data.countries.toList();

    if (kycCountriesList.isNotEmpty) {
      for (var i = 0; i < kycCountriesList.length; i++) {
        final documents = <KycDocumentType>[];

        final acceptedDocuments =
            kycCountriesList[i].acceptedDocuments.toList();

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
  void setMarketInfo(TotalMarketInfoModel value) =>
      marketInfo = value.marketCapChange24H.round(scale: 2);

  @observable
  @ObservableCampaignModelListConverter()
  ObservableList<CampaignModel> marketCampaigns = ObservableList.of([]);
  @action
  void setMarketCampaigns(CampaignResponseModel value) =>
      marketCampaigns = ObservableList.of(value.campaigns);

  @observable
  @ObservableReferralStatsModelListConverter()
  ObservableList<ReferralStatsModel> referralStats = ObservableList.of([]);
  @action
  void setReferralStats(ReferralStatsResponseModel value) =>
      referralStats = ObservableList.of(value.referralStats);

  @observable
  InstrumentsModel? instruments;
  @action
  void setInstruments(InstrumentsModel value) => instruments = value;

  @observable
  @ObservableMarketItemModelListConverter()
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
  PeriodPricesModel? periodPrices;
  @action
  void setPeriodPrices(PeriodPricesModel value) => periodPrices = value;

  @observable
  ClientDetailModel clientDetail = ClientDetailModel(
    baseAssetSymbol: 'USD',
    walletCreationDate: DateTime.now().toString(),
    recivedAt: DateTime.now(),
    isNftEnable: false,
  );
  @action
  void setClientDetail(ClientDetailModel value) {
    clientDetail = value;

    updateBaseCurrency();
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
  @ObservableIndexModelListConverter()
  ObservableList<IndexModel> indicesDetails = ObservableList.of([]);
  @action
  void setIndicesDetails(IndicesModel value) =>
      indicesDetails = ObservableList.of(value.indices);

  @observable
  @ObservablePriceAccuracyListConverter()
  ObservableList<PriceAccuracy> priceAccuracies = ObservableList.of([]);
  @action
  void setPriceAccuracies(PriceAccuracies value) =>
      priceAccuracies = ObservableList.of(value.accuracies);

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

  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  ObservableList<NftModel> nftList = ObservableList.of([]);
  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  ObservableList<NftMarket> allNftList = ObservableList.of([]);
  @action
  void setNFTList(NftCollections value) => nftList = ObservableList.of(
        value.collection
            .map(
              (e) => NftModel(
                id: e.id,
                name: e.name,
                description: e.description,
                category: NftCollectionCategoryEnum.values
                    .firstWhere((x) => x.index == e.category),
                tags: e.tags,
                nftList: [],
                sImage: e.sImage,
                fImage: e.fImage,
                totalVolumeUsd: e.totalVolumeUsd,
                bestOffer: e.bestOffer,
                bestOfferAsset: e.bestOfferAsset,
                ownerCount: e.ownerCount,
                order: e.order,
              ),
            )
            .toList(),
      );

  @observable
  NFTMarkets? nFTMarkets;
  @action
  void setNFTMarket(NFTMarkets value) {
    nFTMarkets = value;
    allNftList.clear();
    for (var i = 0; i < value.nfts.length; i++) {
      allNftList.add(value.nfts[i]);
      final ind = nftList.indexWhere(
        (element) => element.id == value.nfts[i].collectionId,
      );

      if (ind != -1) {
        final localInd = nftList[ind].nftList.indexWhere(
              (element) => element.symbol == value.nfts[i].symbol,
            );

        if (localInd != -1) {
          nftList[ind].nftList[localInd] =
              nftList[ind].nftList[localInd].copyWith(
                    sellAsset: value.nfts[i].sellAsset,
                    sellPrice: value.nfts[i].sellPrice,
                    collectionId: value.nfts[i].collectionId,
                    buyPrice: value.nfts[i].buyPrice,
                    buyAsset: value.nfts[i].buyAsset,
                    ownerChangedAt: value.nfts[i].ownerChangedAt,
                    tradingAsset: value.nfts[i].tradingAsset,
                    fee: value.nfts[i].fee,
                    onSell: value.nfts[i].onSell,
                  );
        } else {
          nftList[ind].nftList.add(value.nfts[i]);
        }
      }
    }

    if (userNFTPortfolio != null) {
      updateUserNft(userNFTPortfolio!);
    }
  }

  @observable
  NftPortfolio? userNFTPortfolio;
  @action
  void setUserNFTPortfolio(NftPortfolio value) {
    userNFTPortfolio = value;

    updateUserNft(value);
  }

  @observable
  @ObservableNftModelListConverter()
  ObservableList<NftModel> userNFTList = ObservableList.of([]);
  @action
  void updateUserNft(NftPortfolio value) {
    userNFTList = ObservableList.of([]);

    for (var i = 0; i < nftList.length; i++) {
      final localNft = <NftMarket>[];

      for (var q = 0; q < nftList[i].nftList.length; q++) {
        if (value.nfts!.contains(nftList[i].nftList[q].symbol)) {
          localNft.add(nftList[i].nftList[q]);
        }
      }

      if (localNft.isNotEmpty) {
        userNFTList.add(
          nftList[i].copyWith(
            nftList: localNft,
          ),
        );
      }
    }
  }

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
  @ObservableCurrencyModelListConverter()
  ObservableList<CurrencyModel> currenciesList = ObservableList.of([]);
  @observable
  @ObservableCurrencyModelListConverter()
  ObservableList<CurrencyModel> currenciesWithHiddenList =
      ObservableList.of([]);

  @action
  void setAssets(AssetsModel value) {
    currenciesList.clear();
    currenciesWithHiddenList.clear();

    for (final asset in value.assets) {
      if (!asset.hideInTerminal) {
        final depositBlockchains = <BlockchainModel>[];
        final withdrawalBlockchains = <BlockchainModel>[];

        for (final blockchain in asset.depositBlockchains) {
          depositBlockchains.add(
            BlockchainModel(
              id: blockchain,
            ),
          );
        }

        for (final blockchain in asset.withdrawalBlockchains) {
          withdrawalBlockchains.add(
            BlockchainModel(
              id: blockchain,
            ),
          );
        }

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
          iconUrl: iconUrlFrom(assetSymbol: asset.symbol),
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
        );

        //if (!currenciesList.contains(currModel)) {
        //  currenciesList.add(currModel);
        //}

        var contains = false;
        for (var i = 0; i < currenciesList.length; i++) {
          if (currenciesList[i].symbol == currModel.symbol) {
            contains = true;
          }
        }

        if (!contains) {
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
          iconUrl: iconUrlFrom(assetSymbol: asset.symbol),
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
        ),
      );
    }

    if (assetsWithdrawalFees != null) {
      updateAssetsWithdrawalFees(assetsWithdrawalFees!);
    }

    if (assetPaymentMethods != null) {
      updateAssetPaymentMethods(assetPaymentMethods!);
    }

    if (assetPaymentMethodsNew != null) {
      updateAssetPaymentMethodsNew(assetPaymentMethodsNew!);
    }

    if (balancesModel != null) {
      updateBalances(balancesModel!);
    }

    if (basePricesModel != null) {
      updateBasePrices(basePricesModel!);
    }

    if (blockchainsModel != null) {
      updateBlockchains(blockchainsModel!);
    }

    if (currenciesList.isNotEmpty) {
      if (recurringBuys.isNotEmpty) {
        for (final element in recurringBuys) {
          for (final currency in currenciesList) {
            final index = currenciesList.indexOf(currency);
            if (currency.symbol == element.toAsset) {
              currenciesList[index] = currency.copyWith(
                recurringBuy: element,
              );
            }
          }
        }
      }
    }

    if (currenciesList.isNotEmpty) {
      updateBaseCurrency();
    }
  }

  @observable
  BalancesModel? balancesModel;
  @action
  void updateBalances(BalancesModel value) {
    balancesModel = value;

    if (currenciesList.isNotEmpty) {
      for (final balance in value.balances) {
        for (final currency in currenciesList) {
          if (currency.symbol == balance.assetId) {
            final index = currenciesList.indexOf(currency);

            currenciesList[index] = currency.copyWith(
              lastUpdate: balance.lastUpdate,
              assetBalance: balance.balance,
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
    }
    getIt.get<ChangeBaseAssetStore>().finishLoading();
  }

  @observable
  BlockchainsModel? blockchainsModel;
  @action
  void updateBlockchains(BlockchainsModel data) {
    blockchainsModel = data;

    if (currenciesList.isNotEmpty) {
      for (final currency in currenciesList) {
        final index = currenciesList.indexOf(currency);

        if (currenciesList[index].depositBlockchains.isNotEmpty) {
          for (final depositBlockchain
              in currenciesList[index].depositBlockchains) {
            final blockchainIndex = currenciesList[index]
                .depositBlockchains
                .indexOf(depositBlockchain);
            for (final blockchain in data.blockchains) {
              if (depositBlockchain.id == blockchain.id) {
                currenciesList[index].depositBlockchains[blockchainIndex] =
                    currenciesList[index]
                        .depositBlockchains[blockchainIndex]
                        .copyWith(
                          tagType: blockchain.tagType,
                          description: blockchain.description,
                          blockchainExplorerUrlTemplate:
                              blockchain.blockchainExplorerUrlTemplate,
                        );
              }
            }
          }
        }

        if (currenciesList[index].withdrawalBlockchains.isNotEmpty) {
          for (final withdrawalBlockchain
              in currenciesList[index].withdrawalBlockchains) {
            final blockchainIndex = currenciesList[index]
                .withdrawalBlockchains
                .indexOf(withdrawalBlockchain);
            for (final blockchain in data.blockchains) {
              if (withdrawalBlockchain.id == blockchain.id) {
                currenciesList[index].withdrawalBlockchains[blockchainIndex] =
                    currenciesList[index]
                        .withdrawalBlockchains[blockchainIndex]
                        .copyWith(
                          tagType: blockchain.tagType,
                          description: blockchain.description,
                          blockchainExplorerUrlTemplate:
                              blockchain.blockchainExplorerUrlTemplate,
                        );
              }
            }
          }
        }
      }
    }
  }

  @observable
  BasePricesModel? basePricesModel;
  @action
  Future<void> updateBasePrices(BasePricesModel value) async {
    basePricesModel = value;

    if (currenciesList.isNotEmpty) {
      for (final currency in currenciesList) {
        final index = currenciesList.indexOf(currency);

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

        if (assetPrice.currentPrice != Decimal.zero) {
          currenciesList[index] = currency.copyWith(
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
          baseCurrencySymbol: sSignalRModules.baseCurrency.symbol,
        );

        final baseTotalEarnAmount = calculateBaseBalance(
          assetSymbol: currency.symbol,
          assetBalance: currency.assetTotalEarnAmount,
          assetPrice: assetPrice,
          baseCurrencySymbol: sSignalRModules.baseCurrency.symbol,
        );

        final baseCurrentEarnAmount = calculateBaseBalance(
          assetSymbol: currency.symbol,
          assetBalance: currency.assetCurrentEarnAmount,
          assetPrice: assetPrice,
          baseCurrencySymbol: sSignalRModules.baseCurrency.symbol,
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

    await getIt<LocalCacheService>().saveSignalR(
      (this as SignalRServiceUpdated).toJson(),
    );
  }

  @observable
  AssetWithdrawalFeeModel? assetsWithdrawalFees;
  @action
  void updateAssetsWithdrawalFees(AssetWithdrawalFeeModel value) {
    assetsWithdrawalFees = value;

    if (currenciesList.isNotEmpty) {
      for (final assetFee in value.assetFees) {
        for (final currency in currenciesList) {
          if (currency.symbol == assetFee.asset) {
            final index = currenciesList.indexOf(currency);
            final assetWithdrawalFees =
                currenciesList[index].assetWithdrawalFees.toList();

            assetWithdrawalFees.add(assetFee);
            currenciesList[index] = currency.copyWith(
              assetWithdrawalFees: assetWithdrawalFees,
            );
          }
        }
      }
    }
  }

  @observable
  RewardsProfileModel? rewardsData;
  @action
  void rewardsProfileMethods(RewardsProfileModel data) {
    rewardsData = data;
  }

  @observable
  bool showPaymentsMethods = false;
  @observable
  AssetPaymentMethods? assetPaymentMethods;
  @observable
  AssetPaymentMethodsNew? assetPaymentMethodsNew;
  @observable
  List<String> paymentMethods = [];
  @action
  void updateAssetPaymentMethods(AssetPaymentMethods value) {
    // showPaymentsMethods = value.showCardsInProfile;
    // assetPaymentMethods = value;
    //
    // if (currenciesList.isNotEmpty) {
    //   for (final info in value.assets) {
    //     for (final currency in currenciesList) {
    //       if (currency.symbol == info.symbol) {
    //         final index = currenciesList.indexOf(currency);
    //         final methods = List<PaymentMethod>.from(info.buyMethods);
    //         final newMethods = List<BuyMethodDto>.from([]);
    //
    //         methods.removeWhere((element) {
    //           return element.type == PaymentMethodType.unsupported;
    //         });
    //         for (final method in methods) {
    //           newMethods.add(BuyMethodDto(
    //             id: method.type,
    //             iconUrl: 'iconUrl',
    //             orderId: 1,
    //             termsAccepted: false,
    //             allowedForSymbols: ['ETH', 'BTC'],
    //             paymentAssets: [
    //               PaymentAsset(
    //                 asset: 'EURO',
    //                 minAmount: Decimal.parse('10'),
    //                 maxAmount: Decimal.parse('100'),
    //                 orderId: 2,
    //               ),
    //               PaymentAsset(
    //                 asset: 'USD',
    //                 minAmount: Decimal.parse('10'),
    //                 maxAmount: Decimal.parse('100'),
    //                 orderId: 1,
    //               ),
    //             ],
    //           ));
    //         }
    //
    //         currenciesList[index] = currency.copyWith(
    //           buyMethods: newMethods,
    //         );
    //       }
    //     }
    //   }
    // }
    //
    // paymentMethods.clear();
    // for (final asset in value.assets) {
    //   for (final method in asset.buyMethods) {
    //     paymentMethods.add(method.type.toString());
    //   }
    // }
  }

  @action
  void updateAssetPaymentMethodsNew(AssetPaymentMethodsNew value) {
    showPaymentsMethods = value.showCardsInProfile;
    assetPaymentMethodsNew = value;
    for (final currency in currenciesList) {
      final index = currenciesList.indexOf(currency);
      final buyMethodsFull = List<BuyMethodDto>.from(value.buy ?? []);
      final buyMethods = List<BuyMethodDto>.from([]);
      final sendMethods = List<SendMethodDto>.from([]);
      final receiveMethods = List<ReceiveMethodDto>.from([]);

      buyMethodsFull.removeWhere((element) {
        return element.id == PaymentMethodType.unsupported;
      });

      for (final buyMethod in buyMethodsFull) {
        if (buyMethod.allowedForSymbols?.contains(currency.symbol) ?? false) {
          buyMethods.add(setCategoryForBuyMethods(buyMethod));
        }
      }
      if (value.send != null) {
        for (final sendMethod in value.send!) {
          if (sendMethod.symbols?.contains(currency.symbol) ?? false) {
            sendMethods.add(sendMethod);
          }
        }
      }
      if (value.receive != null) {
        for (final receiveMethod in value.receive!) {
          if (receiveMethod.symbols?.contains(currency.symbol) ?? false) {
            receiveMethods.add(receiveMethod);
          }
        }
      }
      if (buyMethods.isNotEmpty) {
        buyMethods.sort(
          (a, b) => (a.orderId ?? 0).compareTo(b.orderId ?? 0),
        );
      }
      currenciesList[index] = currency.copyWith(
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

  @action
  void operationHistoryEvent(String operationId) {
    print('operationHistoryEvent');

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
    earnOffersList = ObservableList.of([]);
    showPaymentsMethods = false;
    clientDetail = ClientDetailModel(
      baseAssetSymbol: 'USD',
      walletCreationDate: DateTime.now().toString(),
      recivedAt: DateTime.now(),
      isNftEnable: false,
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
    recurringBuys = ObservableList.of([]);
    cards = const CardsModel(now: 0, cardInfos: []);
    earnProfile = null;
    indicesDetails = ObservableList.of([]);
    marketInfo = Decimal.zero;
    periodPrices = null;
    marketItems = ObservableList.of([]);
    kycCountries = ObservableList.of([]);
    nftList = ObservableList.of([]);
    userNFTList = ObservableList.of([]);
    instruments = null;
    allNftList = ObservableList.of([]);
    nFTMarkets = null;
    userNFTPortfolio = null;
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
        (item) =>
            item.symbol.toLowerCase().contains(searchInput) ||
            item.name.toLowerCase().contains(searchInput),
      )
      .toList();
}
