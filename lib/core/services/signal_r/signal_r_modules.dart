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
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
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
      earnOffersList.clear();
      for (final element in value) {
        if (!earnOffersList.contains(element)) {
          earnOffersList.add(element);
        }
      }
    });

    assetPaymentMethods.listen(
      (value) {
        showPaymentsMethods = value.showCardsInProfile;

        if (currenciesList.isNotEmpty) {
          for (final info in value.assets) {
            for (final currency in currenciesList) {
              if (currency.symbol == info.symbol) {
                final index = currenciesList.indexOf(currency);
                final methods = List<PaymentMethod>.from(info.buyMethods);

                methods.removeWhere((element) {
                  return element.type == PaymentMethodType.unsupported;
                });

                currenciesList[index] = currency.copyWith(
                  buyMethods: methods,
                );
              }
            }
          }
        }
      },
    );

    clientDetails.listen(
      (value) {
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
    );

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
          if (!referralStats.contains(item)) {
            referralStats.add(item);
          }
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
        recurringBuys.clear();
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

    basePrices.listen((value) {
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
    });

    balances.listen((value) {
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
    });

    blockchains.listen((data) {
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
                          );
                }
              }
            }
          }
        }
      }
    });

    assetsWithdrawalFees.listen((value) {
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
    });

    assets.listen((value) {
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

          currenciesList.add(
            CurrencyModel(
              symbol: asset.symbol,
              description: asset.description,
              accuracy: asset.accuracy.toInt(),
              depositMode: asset.depositMode,
              withdrawalMode: asset.withdrawalMode,
              tagType: asset.tagType,
              type: asset.type,
              depositMethods: asset.depositMethods,
              fees: asset.fees,
              withdrawalMethods: asset.withdrawalMethods,
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
            ),
          );
        }

        currenciesWithHiddenList.add(
          CurrencyModel(
            symbol: asset.symbol,
            description: asset.description,
            accuracy: asset.accuracy.toInt(),
            depositMode: asset.depositMode,
            withdrawalMode: asset.withdrawalMode,
            tagType: asset.tagType,
            type: asset.type,
            depositMethods: asset.depositMethods,
            fees: asset.fees,
            withdrawalMethods: asset.withdrawalMethods,
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

      if (currenciesList.isNotEmpty) {
        for (final AssetFeeModel assetFee
            in sSignalRModules.assetsWithdrawalFees.value?.assetFees ?? []) {
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

      if (currenciesList.isNotEmpty) {
        if (sSignalRModules.assetPaymentMethods.value != null) {
          for (final info
              in sSignalRModules.assetPaymentMethods.value!.assets) {
            for (final currency in currenciesList) {
              if (currency.symbol == info.symbol) {
                final index = currenciesList.indexOf(currency);
                final methods = List<PaymentMethod>.from(info.buyMethods);

                methods.removeWhere((element) {
                  return element.type == PaymentMethodType.unsupported;
                });

                currenciesList[index] = currency.copyWith(
                  buyMethods: methods,
                );
              }
            }
          }
        }
      }

      if (currenciesList.isNotEmpty) {
        if (sSignalRModules.balances.value != null) {
          for (final balance in sSignalRModules.balances.value!.balances) {
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
      }

      if (currenciesList.isNotEmpty) {
        for (final currency in currenciesList) {
          final index = currenciesList.indexOf(currency);

          final assetPrice = basePriceFrom(
            prices: sSignalRModules.basePrices.value?.prices ?? [],
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

      if (currenciesList.isNotEmpty) {
        for (final currency in currenciesList) {
          final index = currenciesList.indexOf(currency);

          if (currenciesList[index].depositBlockchains.isNotEmpty) {
            for (final depositBlockchain
                in currenciesList[index].depositBlockchains) {
              final blockchainIndex = currenciesList[index]
                  .depositBlockchains
                  .indexOf(depositBlockchain);
              for (final BlockchainModel blockchain
                  in sSignalRModules.blockchains.value?.blockchains ?? []) {
                if (depositBlockchain.id == blockchain.id) {
                  final depositBlockhainList =
                      currenciesList[index].depositBlockchains.toList();

                  depositBlockhainList[blockchainIndex] =
                      depositBlockhainList[blockchainIndex].copyWith(
                    tagType: blockchain.tagType,
                    description: blockchain.description,
                  );

                  currenciesList[index] = currenciesList[index].copyWith(
                    depositBlockchains: depositBlockhainList,
                  );

                  /*
                  currencies[index].depositBlockchains[blockchainIndex] =
                      currencies[index]
                          .depositBlockchains[blockchainIndex]
                          .copyWith(
                            tagType: blockchain.tagType,
                            description: blockchain.description,
                          );
                          */
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
              for (final BlockchainModel blockchain
                  in sSignalRModules.blockchains.value?.blockchains ?? []) {
                if (withdrawalBlockchain.id == blockchain.id) {
                  final withdrawalBlockchainsList =
                      currenciesList[index].withdrawalBlockchains.toList();
                  withdrawalBlockchainsList[blockchainIndex] =
                      withdrawalBlockchainsList[blockchainIndex].copyWith(
                    tagType: blockchain.tagType,
                    description: blockchain.description,
                  );

                  currenciesList[index] = currenciesList[index].copyWith(
                    withdrawalBlockchains: withdrawalBlockchainsList,
                  );
                  /*
                  currencies[index].withdrawalBlockchains[blockchainIndex] =
                      currencies[index]
                          .withdrawalBlockchains[blockchainIndex]
                          .copyWith(
                            tagType: blockchain.tagType,
                            description: blockchain.description,
                          );
                  */
                }
              }
            }
          }
        }
      }

      if (currenciesList.isNotEmpty) {
        if (sSignalRModules.recurringBuys.isNotEmpty) {
          for (final element
              in sSignalRModules.recurringBuyOS.value!.recurringBuys) {
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

      currenciesList.sort((a, b) => b.baseBalance.compareTo(a.baseBalance));
    });
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
  ObservableList<CurrencyModel> currenciesList = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> currenciesWithHiddenList =
    ObservableList.of([]);

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

  @computed
  List<MarketItemModel> get getMarketPrices => marketReferencesList(
        marketReferences.value,
        currenciesList,
      );

  /*
  @computed
  List<CurrencyModel> get getCurrencies => currenciesList(
        sSignalRModules.assets.value!,
      );
  */

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

  @action
  updateAssets() {}

  @action
  updateBaseCurrency(BaseCurrencyModel newBaseCurrency) {
    baseCurrency = newBaseCurrency;
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
