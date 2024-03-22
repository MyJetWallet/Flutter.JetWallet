import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:isolator/isolator.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/helpers/set_category_for_buy_methods.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/asset_withdrawal_fee_model.dart';
import 'package:simple_networking/modules/signal_r/models/balance_model.dart';
import 'package:simple_networking/modules/signal_r/models/base_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';

enum SignalREvents {
  init,

  setIconsApi,

  // Events
  setAssets,
  getCurrencyModels,
  getCurrenciesWithHiddenListModels,

  updateAssetsWithdrawalFees,
  updateAssetPaymentMethodsNew,
  updateBalances,

  updateBasePricesCurrenciesList,
  updateBasePricesHiddenCurrenciesList,

  updateBlockchains,

  // Events with Data
  setAssetsData,
  getCurrencyModelsData,
  getCurrenciesWithHiddenListModelsData,

  updateAssetsWithdrawalFeesData,
  updateAssetPaymentMethodsNewData,
  updateBalancesData,

  updateBasePricesCurrenciesListData,
  updateBasePricesHiddenCurrenciesListData,

  updateBlockchainsData,

  setBaseCurrency
}

class SignalRBackEnd extends Backend {
  SignalRBackEnd({
    required BackendArgument<void> super.argument,
  });

  String _iconApi = '';

  final List<CurrencyModel> currenciesList = [];
  final List<CurrencyModel> currenciesWithHiddenList = [];

  final List<String> paymentMethods = [];

  BaseCurrencyModel baseCurrency = const BaseCurrencyModel();
  Future<void> setBaseCurrency({required BaseCurrencyModel data, required SignalREvents event}) async {
    baseCurrency = data;
  }

  Future<void> setAssets({required AssetsModel data, required SignalREvents event}) async {
    currenciesList.clear();
    currenciesWithHiddenList.clear();
  }

  Future<void> getCurrencyModels({required AssetsModel data, required SignalREvents event}) async {
    try {
      for (final asset in data.assets) {
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
              api: _iconApi,
            ),
            selectedIndexIconUrl: iconUrlFrom(
              assetSymbol: asset.symbol,
              api: _iconApi,
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
      }
    } catch (e) {
      print('ERROR: $e');
    }

    await send(
      event: SignalREvents.getCurrencyModelsData,
      data: currenciesList,
    );
  }

  Future<void> getCurrenciesWithHiddenListModels({required AssetsModel data, required SignalREvents event}) async {
    try {
      for (final asset in data.assets) {
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
              api: _iconApi,
            ),
            selectedIndexIconUrl: iconUrlFrom(
              assetSymbol: asset.symbol,
              api: _iconApi,
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
    } catch (e) {
      print('HIDDEM ERROR: $e');
    }

    await send(
      event: SignalREvents.getCurrenciesWithHiddenListModelsData,
      data: currenciesWithHiddenList,
    );
  }

  ///

  void _updateAssetsWithdrawalFeesEvent({required AssetWithdrawalFeeModel data, required SignalREvents event}) {
    updateAssetsWithdrawalFees(data);
  }

  void updateAssetsWithdrawalFees(AssetWithdrawalFeeModel value) {
    if (currenciesList.isNotEmpty) {
      for (final assetFee in value.assetFees) {
        final currency = currenciesList.firstWhereOrNull((c) => c.symbol == assetFee.asset);

        if (currency != null) {
          final index = currenciesList.indexOf(currency);
          final assetWithdrawalFees = List.of(currency.assetWithdrawalFees)..add(assetFee);

          currenciesList[index] = currency.copyWith(assetWithdrawalFees: assetWithdrawalFees);
        }
      }

      send(
        event: SignalREvents.updateAssetsWithdrawalFeesData,
        data: currenciesList,
      );
    }
  }

  ///

  void _updateAssetPaymentMethodsNew({required AssetPaymentMethodsNew data, required SignalREvents event}) {
    updateAssetPaymentMethodsNew(data);
  }

  void updateAssetPaymentMethodsNew(AssetPaymentMethodsNew value) {
    for (final currency in currenciesList) {
      final buyMethods = (value.buy ?? [])
          .where((buyMethod) => buyMethod.allowedForSymbols?.contains(currency.symbol) ?? false)
          .map(setCategoryForBuyMethods)
          .toList();

      final sendMethods = (value.send ?? [])
          .where((sendMethod) =>
              sendMethod.symbolNetworkDetails?.any((element) => element.symbol == currency.symbol) ?? false,)
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

    send(
      event: SignalREvents.updateAssetPaymentMethodsNewData,
      data: currenciesList,
    );
  }

  ///

  void _updateBalances({required BalancesModel data, required SignalREvents event}) {
    print(currenciesList.length);

    if (currenciesList.isNotEmpty) {
      for (final balance in data.balances) {
        final currency = currenciesList.firstWhereOrNull((c) => c.symbol == balance.assetId);

        if (currency != null) {
          final index = currenciesList.indexOf(currency);

          // TODO: currency.symbol == 'EUR' ? Decimal.zero
          currenciesList[index] = currency.copyWith(
            lastUpdate: balance.lastUpdate,
            assetBalance: currency.symbol == 'EUR' ? Decimal.zero : balance.balance,
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

      send(
        event: SignalREvents.updateBalancesData,
        data: currenciesList,
      );
    } else {
      send(
        event: SignalREvents.updateBalancesData,
        data: <CurrencyModel>[],
      );
    }
  }

  ///

  void _updateBasePricesCurrenciesList({required BasePricesModel data, required SignalREvents event}) {
    updateBasePricesCurrenciesList(data);
  }

  void _updateBasePricesHiddenCurrenciesList({required BasePricesModel data, required SignalREvents event}) {
    updateBasePricesHiddenCurrenciesList(data);
  }

  void updateBasePricesCurrenciesList(BasePricesModel value) {
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
                assetBalance: Decimal.zero,
                assetPrice: assetPrice,
                baseCurrencySymbol: 'EUR',
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

      send(
        event: SignalREvents.updateBasePricesCurrenciesListData,
        data: currenciesList,
      );
    }
  }

  void updateBasePricesHiddenCurrenciesList(BasePricesModel value) {
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

      send(
        event: SignalREvents.updateBasePricesHiddenCurrenciesListData,
        data: currenciesList,
      );
    }
  }

  ///

  void _updateBlockchains({required BlockchainsModel data, required SignalREvents event}) {
    updateBlockchains(data);
  }

  void updateBlockchains(BlockchainsModel data) {
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

      send(
        event: SignalREvents.updateBlockchainsData,
        data: currenciesList,
      );
    }
  }

  ///

  void setIconsApi({required String data, required SignalREvents event}) {
    _iconApi = data;
  }

  @override
  void initActions() {
    whenEventCome(SignalREvents.setIconsApi).run(setIconsApi);

    whenEventCome(SignalREvents.setAssets).run(setAssets);
    whenEventCome(SignalREvents.getCurrencyModels).run(getCurrencyModels);
    whenEventCome(SignalREvents.getCurrenciesWithHiddenListModels).run(getCurrenciesWithHiddenListModels);

    whenEventCome(SignalREvents.updateAssetsWithdrawalFees).run(_updateAssetsWithdrawalFeesEvent);
    whenEventCome(SignalREvents.updateAssetPaymentMethodsNew).run(_updateAssetPaymentMethodsNew);
    whenEventCome(SignalREvents.updateBalances).run(_updateBalances);

    whenEventCome(SignalREvents.updateBasePricesCurrenciesList).run(_updateBasePricesCurrenciesList);
    whenEventCome(SignalREvents.updateBasePricesHiddenCurrenciesList).run(_updateBasePricesHiddenCurrenciesList);

    whenEventCome(SignalREvents.updateBlockchains).run(_updateBlockchains);

    whenEventCome(SignalREvents.setBaseCurrency).run(setBaseCurrency);
  }
}
