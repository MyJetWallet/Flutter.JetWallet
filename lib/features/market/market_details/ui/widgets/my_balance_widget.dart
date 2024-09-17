import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

class MyBalanceWidget extends StatelessWidget {
  const MyBalanceWidget({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final formatService = getIt.get<FormatService>();
    final baseCurrency = sSignalRModules.baseCurrency;

    final currencies = sSignalRModules.currenciesList;
    final currency = currencyFrom(currencies, marketItem.symbol);

    final store = EarnStore.of(context);

    final positions = store.earnPositions.where(
      (position) =>
          position.assetId == currency.symbol &&
          (position.status == EarnPositionStatus.active || position.status == EarnPositionStatus.closing),
    );

    final earnAmount = positions.fold(Decimal.zero, (sum, el) => sum + (el.baseAmount));

    final earnBaseAnount = formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: marketItem.symbol,
      fromCurrencyAmmount: earnAmount,
      toCurrency: sSignalRModules.baseCurrency.symbol,
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: true,
    );

    final isEarnAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
      (element) => element.id == AssetPaymentProductsEnum.earnProgram,
    );

    var totalBalance = marketItem.baseBalance;

    if (isEarnAvaible) {
      totalBalance = totalBalance + earnBaseAnount;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                intl.market_my_balance,
                style: STStyles.header5,
              ),
              Text(
                '${intl.market_total}: ${getIt<AppStore>().isBalanceHide ? '**** ${baseCurrency.symbol}' : totalBalance.toFormatSum(
                    symbol: baseCurrency.symbol,
                    accuracy: baseCurrency.accuracy,
                  )}',
                style: STStyles.subtitle1,
              ),
            ],
          ),
        ),
        SimpleTableAccount(
          assetIcon: Assets.svg.assets.crypto.defaultPlaceholder.simpleSvg(),
          label: intl.market_wallet,
          rightValue: getIt<AppStore>().isBalanceHide
              ? '**** ${baseCurrency.symbol}'
              : marketItem.baseBalance.toFormatSum(
                  symbol: baseCurrency.symbol,
                  accuracy: baseCurrency.accuracy,
                ),
          supplement: getIt<AppStore>().isBalanceHide
              ? '******* ${marketItem.symbol}'
              : marketItem.assetBalance.toFormatCount(
                  symbol: marketItem.symbol,
                  accuracy: marketItem.assetAccuracy,
                ),
          onTableAssetTap: () {
            sAnalytics.tapOnTheBalanceButtonOnMarketAssetScreen(
              asset: marketItem.symbol,
            );

            onMarketItemTap(
              context: context,
              currency: currency,
            );
          },
        ),
        if (isEarnAvaible)
          SimpleTableAccount(
            assetIcon: Assets.svg.assets.fiat.earn.simpleSvg(),
            label: intl.earn_earn,
            rightValue: getIt<AppStore>().isBalanceHide
                ? '**** ${baseCurrency.symbol}'
                : earnBaseAnount.toFormatSum(
                    symbol: baseCurrency.symbol,
                    accuracy: baseCurrency.accuracy,
                  ),
            supplement: getIt<AppStore>().isBalanceHide
                ? '******* ${marketItem.symbol}'
                : earnAmount.toFormatCount(
                    symbol: marketItem.symbol,
                    accuracy: marketItem.assetAccuracy,
                  ),
            onTableAssetTap: () {
              getIt<BottomBarStore>().setHomeTab(BottomItemType.earn);
              sRouter.popUntilRoot();
            },
          ),
      ],
    );
  }

  void onMarketItemTap({
    required BuildContext context,
    required CurrencyModel currency,
  }) {
    sRouter.popUntilRoot();
    getIt<BottomBarStore>().setHomeTab(BottomItemType.home);

    navigateToWallet(context, currency);
  }
}
