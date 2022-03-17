import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/blockchains_model.dart';
import '../../helpers/calculate_base_balance.dart';
import '../../helpers/icon_url_from.dart';
import '../../models/currency_model.dart';
import '../base_currency_pod/base_currency_pod.dart';
import '../signal_r/assets_spod.dart';
import '../signal_r/balances_spod.dart';
import '../signal_r/base_prices_spod.dart';
import '../signal_r/blockchains_spod.dart';

final currenciesPod = Provider.autoDispose<List<CurrencyModel>>((ref) {
  final assets = ref.watch(assetsSpod);
  final balances = ref.watch(balancesSpod);
  final baseCurrency = ref.watch(baseCurrencyPod);
  final basePrices = ref.watch(basePricesSpod);
  final blockchains = ref.watch(blockchainsSpod);

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
            iconUrl: iconUrlFrom(asset.symbol),
            prefixSymbol: asset.prefixSymbol,
            apy: Decimal.zero,
            assetBalance: Decimal.zero,
            assetCurrentEarnAmount: Decimal.zero,
            assetTotalEarnAmount: Decimal.zero,
            baseBalance: Decimal.zero,
            baseCurrentEarnAmount: Decimal.zero,
            baseTotalEarnAmount: Decimal.zero,
            currentPrice: Decimal.zero,
            dayPriceChange: Decimal.zero,
            earnProgramEnabled: asset.earnProgramEnabled,
          ),
        );
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

  currencies.sort((a, b) => b.baseBalance.compareTo(a.baseBalance));

  return currencies;
});
