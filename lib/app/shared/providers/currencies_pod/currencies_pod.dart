import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/asset_payment_methods.dart';
import '../../../../service/services/signal_r/model/blockchains_model.dart';
import '../../features/recurring/provider/recurring_buys_spod.dart';
import '../../helpers/calculate_base_balance.dart';
import '../../helpers/icon_url_from.dart';
import '../../models/currency_model.dart';
import '../base_currency_pod/base_currency_pod.dart';
import '../signal_r/asset_payment_methods_spod.dart';
import '../signal_r/assets_spod.dart';
import '../signal_r/balances_spod.dart';
import '../signal_r/base_prices_spod.dart';
import '../signal_r/blockchains_spod.dart';

final currenciesPod = Provider.autoDispose<List<CurrencyModel>>((ref) {
  final assets = ref.watch(assetsSpod);
  final balances = ref.watch(balancesSpod);
  final baseCurrency = ref.watch(baseCurrencyPod);
  final basePrices = ref.watch(basePricesSpod);
  final paymentMethods = ref.watch(assetPaymentMethodsSpod);
  final blockchains = ref.watch(blockchainsSpod);
  final recurringBuy = ref.watch(recurringBuySpod);

  final currencies = <CurrencyModel>[];

  assets.whenData((value) {
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
            prefixSymbol: asset.prefixSymbol,
            apy: Decimal.zero,
            apr: Decimal.zero,
            assetBalance: Decimal.zero,
            assetCurrentEarnAmount: Decimal.zero,
            assetTotalEarnAmount: Decimal.zero,
            baseBalance: Decimal.zero,
            baseCurrentEarnAmount: Decimal.zero,
            baseTotalEarnAmount: Decimal.zero,
            currentPrice: Decimal.zero,
            dayPriceChange: Decimal.zero,
            earnProgramEnabled: asset.earnProgramEnabled,
            depositInProcess: Decimal.zero,
          ),
        );
      }
    }
  });

  paymentMethods.whenData((value) {
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

  balances.whenData((value) {
    if (currencies.isNotEmpty) {
      for (final balance in value.balances) {
        for (final currency in currencies) {
          if (currency.symbol == balance.assetId) {
            final index = currencies.indexOf(currency);

            currencies[index] = currency.copyWith(
              reserve: balance.reserve,
              lastUpdate: balance.lastUpdate,
              sequenceId: balance.sequenceId,
              assetBalance: balance.balance,
              assetTotalEarnAmount: balance.totalEarnAmount,
              assetCurrentEarnAmount: balance.currentEarnAmount,
              nextPaymentDate: balance.nextPaymentDate,
              apy: balance.apy,
              apr: balance.apr,
              depositInProcess: balance.depositInProcess,
            );
          }
        }
      }
    }
  });

  basePrices.whenData((data) {
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

  blockchains.whenData((data) {
    if (currencies.isNotEmpty) {
      for (final currency in currencies) {
        final index = currencies.indexOf(currency);

        if (currencies[index].depositBlockchains.isNotEmpty) {
          for (final depositBlockchain
              in currencies[index].depositBlockchains) {
            final blockchainIndex =
                currencies[index].depositBlockchains.indexOf(depositBlockchain);
            for (final blockchain in data.blockchains) {
              if (depositBlockchain.id == blockchain.id) {
                currencies[index].depositBlockchains[blockchainIndex] =
                    currencies[index]
                        .depositBlockchains[blockchainIndex]
                        .copyWith(
                          tagType: blockchain.tagType,
                          description: blockchain.description,
                        );
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
                currencies[index].withdrawalBlockchains[blockchainIndex] =
                    currencies[index]
                        .withdrawalBlockchains[blockchainIndex]
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

  recurringBuy.whenData((data) {
    if (currencies.isNotEmpty) {
      if (data.recurringBuys.isNotEmpty) {
        for (final element in data.recurringBuys) {
          for (final currency in currencies) {
            final index = currencies.indexOf(currency);
            if (currency.symbol == element.toAsset) {
              currencies[index] = currency.copyWith(
                recurringBuy: element,
                isRecurring: true,
              );
            } else {
              currencies[index] = currency.copyWith(
                isRecurring: false,
              );
            }
          }
        }
      }
    }
  });

  currencies.sort((a, b) => b.baseBalance.compareTo(a.baseBalance));

  return currencies;
});
