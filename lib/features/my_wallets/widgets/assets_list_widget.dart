import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/modules/icons/24x24/public/delete_asset/simple_delete_asset.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

class AssetsListWidget extends StatefulObserverWidget {
  const AssetsListWidget({super.key});

  @override
  State<AssetsListWidget> createState() => _AssetsListWidgetState();
}

class _AssetsListWidgetState extends State<AssetsListWidget> {
  bool isMoving = false;
  final store = MyWalletsSrore();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return ReorderableListView(
      proxyDecorator: _proxyDecorator,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      onReorderStart: (_) {
        setState(() {
          isMoving = true;
        });
      },
      onReorderEnd: (_) {
        setState(() {
          isMoving = false;
        });
      },
      onReorder: store.onReorder,
      children: [
        for (int index = 0; index < store.currencies.length; index += 1)
          Slidable(
            key: ValueKey(store.currencies[index].symbol),
            endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const StretchMotion(),
              children: [
                CustomSlidableAction(
                  onPressed: (context) {
                    store.onDelete(index);
                  },
                  backgroundColor: colors.red,
                  foregroundColor: colors.white,
                  child: SDeleteAssetIcon(
                    color: colors.white,
                  ),
                ),
              ],
            ),
            child: _MyWalletsItem(
              isMoving: isMoving,
              currency: store.currencies[index],
            ),
          ),
      ],
    );
  }

  Widget _proxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    final colors = sKit.colors;

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.white,
              boxShadow: [
                BoxShadow(
                  color: colors.grey1.withOpacity(0.2),
                  blurRadius: 20,
                ),
              ],
            ),
            child: _MyWalletsItem(
              isMoving: true,
              currency: store.currencies[index],
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _MyWalletsItem extends StatelessWidget {
  const _MyWalletsItem({
    required this.isMoving,
    required this.currency,
  });

  final CurrencyModel currency;
  final bool isMoving;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final marketItems = sSignalRModules.marketItems;

    return SWalletItem(
      height: 80,
      key: UniqueKey(),
      isBalanceHide: getIt<AppStore>().isBalanceHide,
      decline: currency.dayPercentChange.isNegative,
      icon: SNetworkSvg24(
        url: currency.iconUrl,
      ),
      baseCurrPrefix: baseCurrency.prefix,
      primaryText: currency.description,
      amount: currency.volumeBaseBalance(baseCurrency),
      secondaryText: getIt<AppStore>().isBalanceHide
          ? currency.symbol
          : currency.volumeAssetBalance,
      onTap: () {
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
          navigateToWallet(
            context,
            currency,
          );
        }
      },
      removeDivider: true,
      isPendingDeposit: currency.isPendingDeposit,
      isMoving: isMoving,
      priceFieldHeight: 44,
    );
  }
}
