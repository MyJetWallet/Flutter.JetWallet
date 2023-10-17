import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

class MyWalletsAssetItem extends StatelessObserverWidget {
  const MyWalletsAssetItem({
    required this.isMoving,
    required this.currency,
  });

  final CurrencyModel currency;
  final bool isMoving;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final marketItems = sSignalRModules.marketItems;

    var secondaryText = '';

    if (baseCurrency.symbol != currency.symbol) {
      secondaryText = getIt<AppStore>().isBalanceHide ? currency.symbol : currency.volumeAssetBalance;
    }

    return SWalletItem(
      height: 80,
      key: UniqueKey(),
      isBalanceHide: getIt<AppStore>().isBalanceHide,
      decline: currency.dayPercentChange.isNegative,
      icon: SNetworkSvg24(
        url: currency.iconUrl,
      ),
      baseCurrencySymbol: baseCurrency.symbol,
      primaryText: currency.description,
      amount: currency.volumeBaseBalance(baseCurrency),
      secondaryText: secondaryText,
      onTap: !isMoving
          ? () {
              sAnalytics.tapOnFavouriteWalletOnWalletsScreen(
                openedAsset: currency.symbol,
              );
              if (currency.type == AssetType.indices) {
                sRouter.push(
                  MarketDetailsRouter(
                    marketItem: marketItemFrom(
                      marketItems,
                      currency.symbol,
                    ),
                  ),
                );
              } else {
                sRouter
                    .push(
                  WalletRouter(
                    currency: currency,
                  ),
                )
                    .then(
                  (value) {
                    sAnalytics.tapOnTheButtonBackOrSwipeToBackOnCryptoFavouriteWalletScreen(
                      openedAsset: currency.symbol,
                    );
                  },
                );
              }
            }
          : null,
      removeDivider: true,
      isPendingDeposit: currency.isPendingDeposit,
      isMoving: isMoving,
      priceFieldHeight: 44,
    );
  }
}
