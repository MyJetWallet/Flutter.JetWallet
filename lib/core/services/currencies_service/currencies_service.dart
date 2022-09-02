import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';

part 'currencies_service.g.dart';

final sCurrencies = getIt.get<CurrenciesService>();

class CurrenciesService = _CurrenciesServiceBase with _$CurrenciesService;

abstract class _CurrenciesServiceBase with Store {
  @action
  void init() {
    sSignalRModules.assets.listen(
      (value) {
        print('CurrenciesService');

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

            currencies.add(
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
        }
      },
    );

    sSignalRModules.assetsWithdrawalFees.listen((value) {
      if (currencies.isNotEmpty) {
        for (final assetFee in value.assetFees) {
          for (final currency in currencies) {
            if (currency.symbol == assetFee.asset) {
              final index = currencies.indexOf(currency);
              final assetWithdrawalFees =
                  currencies[index].assetWithdrawalFees.toList();
              assetWithdrawalFees.add(assetFee);
              currencies[index] = currency.copyWith(
                assetWithdrawalFees: assetWithdrawalFees,
              );
            }
          }
        }
      }
    });

    sSignalRModules.assetPaymentMethods.listen((value) {
      if (currencies.isNotEmpty) {
        for (final info in value.assets) {
          for (final currency in currencies) {
            if (currency.symbol == info.symbol) {
              final index = currencies.indexOf(currency);
              final methods = List<PaymentMethod>.from(info.buyMethods);

              methods.removeWhere((element) {
                return element.type == PaymentMethodType.unsupported;
              });

              currencies[index] = currency.copyWith(
                buyMethods: methods,
              );
            }
          }
        }
      }
    });

    sSignalRModules.balances.listen((value) {
      if (currencies.isNotEmpty) {
        for (final balance in value.balances) {
          for (final currency in currencies) {
            if (currency.symbol == balance.assetId) {
              final index = currencies.indexOf(currency);

              currencies[index] = currency.copyWith(
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

    sSignalRModules.basePrices.listen((data) {
      if (currencies.isNotEmpty) {
        for (final currency in currencies) {
          final index = currencies.indexOf(currency);

          final assetPrice = basePriceFrom(
            prices: data.prices,
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

          currencies[index] = currency.copyWith(
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

    sSignalRModules.blockchains.listen((data) {
      if (currencies.isNotEmpty) {
        for (final currency in currencies) {
          final index = currencies.indexOf(currency);

          if (currencies[index].depositBlockchains.isNotEmpty) {
            for (final depositBlockchain
                in currencies[index].depositBlockchains) {
              final blockchainIndex = currencies[index]
                  .depositBlockchains
                  .indexOf(depositBlockchain);
              for (final blockchain in data.blockchains) {
                if (depositBlockchain.id == blockchain.id) {
                  final depositBlockhainList =
                      currencies[index].depositBlockchains.toList();

                  depositBlockhainList[blockchainIndex] =
                      depositBlockhainList[blockchainIndex].copyWith(
                    tagType: blockchain.tagType,
                    description: blockchain.description,
                  );

                  currencies[index] = currencies[index].copyWith(
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

          if (currencies[index].withdrawalBlockchains.isNotEmpty) {
            for (final withdrawalBlockchain
                in currencies[index].withdrawalBlockchains) {
              final blockchainIndex = currencies[index]
                  .withdrawalBlockchains
                  .indexOf(withdrawalBlockchain);
              for (final blockchain in data.blockchains) {
                if (withdrawalBlockchain.id == blockchain.id) {
                  final withdrawalBlockchainsList =
                      currencies[index].withdrawalBlockchains.toList();
                  withdrawalBlockchainsList[blockchainIndex] =
                      withdrawalBlockchainsList[blockchainIndex].copyWith(
                    tagType: blockchain.tagType,
                    description: blockchain.description,
                  );

                  currencies[index] = currencies[index].copyWith(
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
    });

    sSignalRModules.recurringBuyOS.listen((data) {
      if (currencies.isNotEmpty) {
        if (data.recurringBuys.isNotEmpty) {
          for (final element in data.recurringBuys) {
            for (final currency in currencies) {
              final index = currencies.indexOf(currency);
              if (currency.symbol == element.toAsset) {
                currencies[index] = currency.copyWith(
                  recurringBuy: element,
                );
              }
            }
          }
        }
      }
    });

    currencies.sort((a, b) => b.baseBalance.compareTo(a.baseBalance));
  }

  @observable
  List<CurrencyModel> currencies = [];
}
