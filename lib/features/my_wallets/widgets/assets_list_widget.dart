import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/my_wallets/helper/currencies_for_my_wallet.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet/set_active_assets_request_model.dart';

class AssetsListWidget extends StatefulObserverWidget {
  const AssetsListWidget({super.key});

  @override
  State<AssetsListWidget> createState() => _AssetsListWidgetState();
}

class _AssetsListWidgetState extends State<AssetsListWidget> {
  List<CurrencyModel> currenciesList = [];
  bool isMoving = false;
  @override
  void initState() {
    super.initState();
    final currencies = sSignalRModules.currenciesList;
    currenciesList.addAll(currenciesForMyWallet(currencies));
  }

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final marketItems = sSignalRModules.marketItems;

    Widget proxyDecorator(
      Widget child,
      int index,
      Animation<double> animation,
    ) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Material(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x51777C85),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: SWalletItem(
                height: 80,
                key: UniqueKey(),
                isBalanceHide: getIt<AppStore>().isBalanceHide,
                decline: currenciesList[index].dayPercentChange.isNegative,
                icon: SNetworkSvg24(
                  url: currenciesList[index].iconUrl,
                ),
                baseCurrPrefix: baseCurrency.prefix,
                primaryText: currenciesList[index].description,
                amount: currenciesList[index].volumeBaseBalance(baseCurrency),
                secondaryText: getIt<AppStore>().isBalanceHide
                    ? currenciesList[index].symbol
                    : currenciesList[index].volumeAssetBalance,
                onTap: () {
                  if (currenciesList[index].type == AssetType.indices) {
                    sRouter.push(
                      MarketDetailsRouter(
                        marketItem: marketItemFrom(
                          marketItems,
                          currenciesList[index].symbol,
                        ),
                      ),
                    );
                  } else {
                    navigateToWallet(
                      context,
                      currenciesList[index],
                    );
                  }
                },
                removeDivider: true,
                isPendingDeposit: currenciesList[index].isPendingDeposit,
                isMoving: isMoving,
              ),
            ),
          );
        },
        child: child,
      );
    }

    return ReorderableListView(
      proxyDecorator: proxyDecorator,
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
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = currenciesList.removeAt(oldIndex);
          currenciesList.insert(newIndex, item);
        });

        final activeAssets = <ActiveAsset>[];
        for (var index = 0; index < currenciesList.length; index++) {
          activeAssets.add(
            ActiveAsset(
              assetSymbol: currenciesList[index].symbol,
              order: index,
            ),
          );
        }
        final model = SetActiveAssetsRequestModel(activeAssets: activeAssets);
        getIt
            .get<SNetwork>()
            .simpleNetworking
            .getWalletModule()
            .setActiveAssets(
              model,
            );
      },
      children: [
        for (int index = 0; index < currenciesList.length; index += 1)
          Slidable(
            key: ValueKey(currenciesList[index].symbol),
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    setState(() {
                      currenciesList.removeAt(index);
                    });

                    final activeAssets = <ActiveAsset>[];
                    for (var index = 0;
                        index < currenciesList.length;
                        index++) {
                      activeAssets.add(
                        ActiveAsset(
                          assetSymbol: currenciesList[index].symbol,
                          order: index,
                        ),
                      );
                    }
                    final model =
                        SetActiveAssetsRequestModel(activeAssets: activeAssets);
                    getIt
                        .get<SNetwork>()
                        .simpleNetworking
                        .getWalletModule()
                        .setActiveAssets(
                          model,
                        );
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: SWalletItem(
              height: 80,
              key: UniqueKey(),
              isBalanceHide: getIt<AppStore>().isBalanceHide,
              decline: currenciesList[index].dayPercentChange.isNegative,
              icon: SNetworkSvg24(
                url: currenciesList[index].iconUrl,
              ),
              baseCurrPrefix: baseCurrency.prefix,
              primaryText: currenciesList[index].description,
              amount: currenciesList[index].volumeBaseBalance(baseCurrency),
              secondaryText: getIt<AppStore>().isBalanceHide
                  ? currenciesList[index].symbol
                  : currenciesList[index].volumeAssetBalance,
              onTap: () {
                if (currenciesList[index].type == AssetType.indices) {
                  sRouter.push(
                    MarketDetailsRouter(
                      marketItem: marketItemFrom(
                        marketItems,
                        currenciesList[index].symbol,
                      ),
                    ),
                  );
                } else {
                  navigateToWallet(
                    context,
                    currenciesList[index],
                  );
                }
              },
              removeDivider: true,
              isPendingDeposit: currenciesList[index].isPendingDeposit,
              isMoving: isMoving,
            ),
          ),
      ],
    );
  }
}
