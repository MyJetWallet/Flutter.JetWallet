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
import 'package:simple_kit/modules/icons/24x24/public/start_reorder/simple_start_reorder_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

class AssetsListWidget extends StatefulObserverWidget {
  const AssetsListWidget({super.key});

  @override
  State<AssetsListWidget> createState() => _AssetsListWidgetState();
}

class _AssetsListWidgetState extends State<AssetsListWidget> {
  final store = MyWalletsSrore();

  @override
  Widget build(BuildContext context) {
    final list = slidableItems();

    return Column(
      children: [
        if (store.isReordering) ...[
          _ChangeOrderWidget(
            onPressedDone: store.onEndReordering,
          ),
          ReorderableListView(
            proxyDecorator: _proxyDecorator,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: store.onReorder,
            children: slidableItems(),
          ),
        ] else
          ...list,
      ],
    );
  }

  List<Widget> slidableItems() {
    final colors = sKit.colors;
    final list = <Widget>[];

    for (var index = 0; index < store.currencies.length; index += 1) {
      list.add(
        Slidable(
          key: ValueKey(store.currencies[index].symbol),
          startActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const StretchMotion(),
            children: [
              CustomSlidableAction(
                onPressed: (context) {
                  store.onStartReordering();
                },
                backgroundColor: colors.purple,
                foregroundColor: colors.white,
                child: SStartReorderIcon(
                  color: colors.white,
                ),
              ),
            ],
          ),
          endActionPane: store.currencies[index].isAssetBalanceEmpty
              ? ActionPane(
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
                )
              : null,
          child: _MyWalletsItem(
            isMoving: store.isReordering,
            currency: store.currencies[index],
          ),
        ),
      );
    }

    return list;
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

class _MyWalletsItem extends StatelessObserverWidget {
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
      baseCurrencySymbol: baseCurrency.symbol,
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

class _ChangeOrderWidget extends StatelessWidget {
  const _ChangeOrderWidget({
    required this.onPressedDone,
  });

  final void Function() onPressedDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change order',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  Text(
                    'Move wallets up and down',
                    style: TextStyle(
                      color: Color(0xFFA8B0BA),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F4F8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onPressedDone,
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Color(0xFF374CFA),
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SpaceH10(),
          const SDivider(),
        ],
      ),
    );
  }
}
