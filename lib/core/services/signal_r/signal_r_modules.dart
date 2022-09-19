import 'dart:async';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/helpers/currencies.dart';
import 'package:jetwallet/core/services/signal_r/helpers/market_references.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_country_model.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/market_details/helper/calculate_percent_change.dart';
import 'package:jetwallet/features/market/market_details/model/return_rates_model.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/store/search_store.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
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
import 'package:simple_networking/modules/signal_r/models/period_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/price_accuracies.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_response_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_info_model.dart';
import 'package:simple_networking/modules/signal_r/models/referral_stats_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';

part 'signal_r_modules.g.dart';

late final SignalRModules sSignalRModules;

class SignalRModules = _SignalRModulesBase with _$SignalRModules;

abstract class _SignalRModulesBase with Store {
  _SignalRModulesBase() {
    print('SignalRModules START');
    clearSignalRModule();

    //sSignalRModules = SignalRModules();

    earnOffers.listen((value) {
      for (final element in value) {
        if (!earnOffersList.contains(element)) {
          earnOffersList.add(element);
        }
      }
    });

    assetPaymentMethods.listen(
      (value) {
        showPaymentsMethods = value.showCardsInProfile;
      },
    );

    clientDetails.listen(
      (value) {
        print('CLIENT DETAILS');
        clientDetail = value;

        assets.listen(
          (assetsData) {
            final elements = assetsData.assets.where((element) {
              return element.symbol == value.baseAssetSymbol;
            });

            baseCurrency = BaseCurrencyModel(
              prefix: elements.isEmpty ? null : elements.first.prefixSymbol,
              symbol: value.baseAssetSymbol,
              accuracy: elements.isEmpty ? 0 : elements.first.accuracy.toInt(),
            );
          },
        );
      },
    ).onError((error) {
      print('CLIENT DETAILS $error');
    });

    cardLimits.listen(
      (value) {
        cardLimitsModel = value;
      },
    );

    marketCampaignsOS.listen(
      (value) {
        for (final marketCampaign in value.campaigns) {
          if (!marketCampaigns.contains(marketCampaign)) {
            marketCampaigns.add(marketCampaign);
          }
        }
      },
    );

    priceAccuraciesOS.listen(
      (value) {
        final accuracies = value.accuracies;

        for (final accuracy in accuracies) {
          if (!priceAccuracies.contains(accuracy)) {
            priceAccuracies.add(accuracy);
          }
        }
      },
    );

    referralStatsOS.listen(
      (value) {
        for (final item in value.referralStats) {
          referralStats.add(item);
        }
      },
    );

    keyValueOS.listen(
      (value) {
        keyValue = value;
      },
    );

    referralInfoOS.listen(
      (value) {
        referralInfo = value;
      },
    );

    recurringBuyOS.listen(
      (value) {
        for (final element in value.recurringBuys) {
          if (!recurringBuys.contains(element)) {
            recurringBuys.add(element);
          }
        }
      },
    );

    cardsOS.listen(
      (value) {
        cards = value;
      },
    );

    earnProfileOS.listen(
      (value) {
        earnProfile = value;
      },
    );

    indicesOS.listen(
      (value) {
        for (final index in value.indices) {
          indicesDetails.add(index);
        }
      },
    );

    marketInfoOS.listen(
      (value) {
        marketInfo = value.marketCapChange24H.round(scale: 2);
      },
    );

    periodPricesOS.listen(
      (value) {
        periodPrices = value;
      },
    );

    marketReferences.listen(
      (value) {
        print('MARKET REFERENCES');

        final items = <MarketItemModel>[];

        for (final marketReference in value.references) {
          late CurrencyModel currency;

          try {
            currency = sSignalRModules.getCurrencies.firstWhere(
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

        print(items);

        marketItems = ObservableList.of(
          _formattedItems(
            items,
            getIt.get<SearchStore>().search,
          ),
        );
      },
    ).onError(
      (error) {
        print(error);
      },
    );

    kycCountriesOS.listen(
      (data) {
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

            value.add(
              KycCountryModel(
                countryCode: kycCountriesList[i].countryCode,
                countryName: kycCountriesList[i].countryName,
                acceptedDocuments: documents,
                isBlocked: kycCountriesList[i].isBlocked,
              ),
            );
          }
        }

        kycCountries = ObservableList.of(value);
      },
    );
  }

  @observable
  ObservableStream<AssetPaymentMethods> assetPaymentMethods = ObservableStream(
    getIt.get<SignalRService>().paymentMethods(),
  );

  @observable
  bool showPaymentsMethods = false;

  @observable
  ObservableStream<AssetsModel> assets = ObservableStream(
    getIt.get<SignalRService>().assets(),
  );

  @observable
  ObservableStream<AssetWithdrawalFeeModel> assetsWithdrawalFees =
      ObservableStream(
    getIt.get<SignalRService>().assetWithdrawalFee(),
  );

  @observable
  ObservableStream<BalancesModel> balances = ObservableStream(
    getIt.get<SignalRService>().balances(),
  );

  @observable
  ObservableStream<BasePricesModel> basePrices = ObservableStream(
    getIt.get<SignalRService>().basePrices(),
  );

  @observable
  ObservableStream<BlockchainsModel> blockchains = ObservableStream(
    getIt.get<SignalRService>().blockchains(),
  );

  @observable
  ObservableStream<CardsModel> cardsOS = ObservableStream(
    getIt.get<SignalRService>().cards(),
  );

  @observable
  CardsModel cards = const CardsModel(now: 0, cardInfos: []);

  @observable
  ObservableStream<bool> initFinished = ObservableStream(
    getIt.get<SignalRService>().initFinished(),
  );

  @observable
  ObservableStream<InstrumentsModel> instruments = ObservableStream(
    getIt.get<SignalRService>().instruments(),
  );

  @observable
  ObservableStream<PeriodPricesModel> periodPricesOS = ObservableStream(
    getIt.get<SignalRService>().periodPrices(),
  );

  @observable
  PeriodPricesModel? periodPrices;

  @observable
  ObservableStream<PriceAccuracies> priceAccuraciesOS = ObservableStream(
    getIt.get<SignalRService>().priceAccuracies(),
  );

  @observable
  ObservableList<PriceAccuracy> priceAccuracies = ObservableList.of([]);

  @observable
  ObservableStream<RecurringBuysResponseModel> recurringBuyOS =
      ObservableStream(
    getIt.get<SignalRService>().recurringBuy(),
  );

  @observable
  ObservableList<RecurringBuysModel> recurringBuys = ObservableList.of([]);

  @observable
  ObservableStream<List<EarnOfferModel>> earnOffers = ObservableStream(
    getIt.get<SignalRService>().earnOffers(),
  );

  @observable
  ObservableList<EarnOfferModel> earnOffersList = ObservableList.of([]);

  @observable
  ObservableStream<EarnProfileModel> earnProfileOS = ObservableStream(
    getIt.get<SignalRService>().earnProfile(),
  );

  @observable
  EarnProfileModel? earnProfile;

  @observable
  ObservableStream<CampaignResponseModel> marketCampaignsOS = ObservableStream(
    getIt.get<SignalRService>().marketCampaigns(),
  );

  @observable
  ObservableList<CampaignModel> marketCampaigns = ObservableList.of([]);

  @observable
  ObservableStream<ReferralInfoModel> referralInfoOS = ObservableStream(
    getIt.get<SignalRService>().referralInfo(),
  );

  @observable
  ReferralInfoModel referralInfo = const ReferralInfoModel(
    descriptionLink: '',
    referralLink: '',
    title: '',
    referralTerms: [],
    referralCode: '',
  );

  @observable
  ObservableStream<ClientDetailModel> clientDetails = ObservableStream(
    getIt.get<SignalRService>().clientDetail(),
  );

  @observable
  ClientDetailModel clientDetail = ClientDetailModel(
    baseAssetSymbol: 'USD',
    walletCreationDate: DateTime.now().toString(),
    recivedAt: DateTime.now(),
  );

  @observable
  ObservableStream<CardLimitsModel> cardLimits = ObservableStream(
    getIt.get<SignalRService>().cardLimits(),
  );

  @observable
  CardLimitsModel? cardLimitsModel;

  @observable
  ObservableStream<ReferralStatsResponseModel> referralStatsOS =
      ObservableStream(
    getIt.get<SignalRService>().referralStats(),
  );

  @observable
  ObservableList<ReferralStatsModel> referralStats = ObservableList.of([]);

  @observable
  ObservableStream<KeyValueModel> keyValueOS = ObservableStream(
    getIt.get<SignalRService>().keyValue(),
  );

  @observable
  KeyValueModel keyValue = const KeyValueModel(
    now: 0,
    keys: [],
  );

  @observable
  ObservableStream<MarketReferencesModel> marketReferences = ObservableStream(
    getIt.get<SignalRService>().marketReferences(),
  );

  @observable
  ObservableList<MarketItemModel> marketItems = ObservableList.of([]);

  @observable
  ObservableStream<IndicesModel> indicesOS = ObservableStream(
    getIt.get<SignalRService>().indices(),
  );

  @observable
  ObservableStream<TotalMarketInfoModel> marketInfoOS = ObservableStream(
    getIt.get<SignalRService>().marketInfo(),
  );

  @observable
  ObservableStream<KycCountriesResponseModel> kycCountriesOS = ObservableStream(
    getIt.get<SignalRService>().kycCountries(),
  );

  @observable
  ObservableList<KycCountryModel> kycCountries = ObservableList.of([]);

  @observable
  Decimal marketInfo = Decimal.zero;

  @observable
  MarketInfoResponseModel? marketInfoModel;

  @observable
  ObservableList<IndexModel> indicesDetails = ObservableList.of([]);

  @observable
  BaseCurrencyModel baseCurrency = const BaseCurrencyModel();

  @action
  ReturnRatesModel? getReturnRates(String assetId) {
    try {
      final currencies = sSignalRModules.getCurrencies;

      final periodPrice = periodPrices!.prices.firstWhere(
        (element) => element.assetSymbol == assetId,
      );

      final currency = currencies.firstWhere(
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

  @computed
  List<MarketItemModel> get getMarketPrices => marketReferencesList(
        marketReferences.value,
        getCurrencies,
      );

  @computed
  List<CurrencyModel> get getCurrencies => currenciesList();

  @action
  void clearSignalRModule() {
    earnOffersList = ObservableList.of([]);
    showPaymentsMethods = false;
    clientDetail = ClientDetailModel(
      baseAssetSymbol: 'USD',
      walletCreationDate: DateTime.now().toString(),
      recivedAt: DateTime.now(),
    );
    baseCurrency = const BaseCurrencyModel();
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
    marketInfoModel = null;
    periodPrices = null;
    marketItems = ObservableList.of([]);
    kycCountries = ObservableList.of([]);
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
