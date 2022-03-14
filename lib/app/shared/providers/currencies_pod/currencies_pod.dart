import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/payment_methods.dart';
import '../../helpers/calculate_base_balance.dart';
import '../../helpers/icon_url_from.dart';
import '../../models/currency_model.dart';
import '../base_currency_pod/base_currency_pod.dart';
import '../signal_r/asset_payment_methods_spod.dart';
import '../signal_r/assets_spod.dart';
import '../signal_r/balances_spod.dart';
import '../signal_r/base_prices_spod.dart';

final currenciesPod = Provider.autoDispose<List<CurrencyModel>>((ref) {
  final assets = ref.watch(assetsSpod);
  final balances = ref.watch(balancesSpod);
  final baseCurrency = ref.watch(baseCurrencyPod);
  final basePrices = ref.watch(basePricesSpod);
  final paymentMethods = ref.watch(assetPaymentMethodsSpod);

  final currencies = <CurrencyModel>[];

  assets.whenData((value) {
    for (final asset in value.assets) {
      if (!asset.hideInTerminal) {
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
            depositBlockchains: asset.depositBlockchains,
            withdrawalBlockchains: asset.withdrawalBlockchains,
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

  paymentMethods.whenData((value) {
    if (currencies.isNotEmpty) {
      for (final info in value.assets) {
        for (final currency in currencies) {
          if (currency.symbol == info.symbol) {
            final index = currencies.indexOf(currency);

            currencies[index] = currency.copyWith(
              buyMethods: List<PaymentMethod>.from(info.buyMethods),
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

  return currencies;
});
