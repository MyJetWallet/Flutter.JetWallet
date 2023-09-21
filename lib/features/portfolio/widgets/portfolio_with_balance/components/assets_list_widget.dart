import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

class AssetsListWidget extends StatelessWidget {
  const AssetsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final currencies = sSignalRModules.currenciesList;
    final marketItems = sSignalRModules.marketItems;
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);
    final currenciesList = currencies.toList();
    sortCurrenciesMyAssets(currenciesList);

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: getIt<AppStore>().showAllAssets
          ? currenciesList.length
          : itemsWithBalance.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final actualItem = getIt<AppStore>().showAllAssets
            ? currenciesList[index]
            : itemsWithBalance[index];

        return Column(
          children: [
            Observer(
              builder: (context) {
                return SWalletItem(
                  height: 80,
                  key: UniqueKey(),
                  isBalanceHide: getIt<AppStore>().isBalanceHide,
                  decline: actualItem.dayPercentChange.isNegative,
                  icon: SNetworkSvg24(
                    url: actualItem.iconUrl,
                  ),
                  baseCurrPrefix: baseCurrency.prefix,
                  primaryText: actualItem.description,
                  amount: actualItem.volumeBaseBalance(baseCurrency),
                  secondaryText: getIt<AppStore>().isBalanceHide
                      ? actualItem.symbol
                      : actualItem.volumeAssetBalance,
                  onTap: () {
                    if (actualItem.type == AssetType.indices) {
                      sRouter.push(
                        MarketDetailsRouter(
                          marketItem: marketItemFrom(
                            marketItems,
                            actualItem.symbol,
                          ),
                        ),
                      );
                    } else {
                      navigateToWallet(
                        context,
                        actualItem,
                      );
                    }
                  },
                  removeDivider: true,
                  isPendingDeposit: actualItem.isPendingDeposit,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
