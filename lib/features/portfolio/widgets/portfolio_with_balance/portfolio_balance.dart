import 'package:decimal/decimal.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/components/balance_in_process.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/components/portfolio_sliver_appbar.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/actual_in_progress_operation.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/portfolio_screen_gradient.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

import '../../../../utils/helpers/currencies_helpers.dart';
import 'components/hide_zero.dart';

class PortfolioBalance extends StatefulObserverWidget {
  const PortfolioBalance({super.key});

  @override
  State<PortfolioBalance> createState() => _PortfolioBalanceState();
}

class _PortfolioBalanceState extends State<PortfolioBalance> {
  ScrollController scrollController = ScrollController();

  ScrollController? gCon;

  DraggableScrollableController controller = DraggableScrollableController();

  bool lastStatus = true;
  double _offset = 0;

  @override
  void initState() {
    //scrollController.addListener(_scrollListener);
    controller.addListener(_draggableListener);

    getIt<EventBus>().on<ResetScrollMyAssets>().listen((event) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );

      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );

      if (gCon != null) {
        gCon!.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceIn,
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    //scrollController.removeListener(_scrollListener);
    controller.removeListener(_draggableListener);
    super.dispose();
  }

  void _draggableListener() {
    setState(() {
      //441
      //588
      _offset = controller.size;
    });
  }

  Widget _balanceInProgressIcon(
    CurrencyModel currency,
  ) {
    if (!currency.isSingleTypeInProgress) {
      return const SDepositTotalIcon();
    }
    if (currency.transfersInProcessTotal > Decimal.zero) {
      return const SDepositSendIcon();
    } else if (currency.earnInProcessTotal > Decimal.zero) {
      return const SDepositEarnIcon();
    } else if (currency.buysInProcessTotal > Decimal.zero) {
      return const SDepositBuyIcon();
    }

    return const SDepositTotalIcon();
  }

  String _balanceInProgressText(
    CurrencyModel currency,
  ) {
    if (currency.isSingleTypeInProgress) {
      return volumeFormat(
        decimal: currency.totalAmountInProcess,
        accuracy: currency.accuracy,
        symbol: currency.symbol,
        prefix: currency.prefixSymbol,
      );
    }

    return intl.portfolioWithBalanceBody_transactions;
  }

  String _balanceInProgressLeadText(
    CurrencyModel currency,
  ) {
    if (currency.isSingleTypeInProgress) {
      return actualInProcessOperationName(
        currency,
        intl.portfolioWithBalanceBody_send,
        intl.portfolioWithBalanceBody_earn,
        intl.portfolioWithBalanceBody_simplex,
      );
    }

    return '${counterOfOperationInProgressTransactions(currency)} ';
  }

  double getMaxChildSize() {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    if (devicePixelRatio <= 2.2) {
      return 0.7;
    }
    if (devicePixelRatio >= 2.2 && devicePixelRatio < 3) {
      return 0.77;
    }
    if (devicePixelRatio >= 3) {
      return 0.77;
    }

    return 0.77;
  }

  double getMinChildSize() {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    if (MediaQuery.of(context).size.height <= 700) {
      return 0.45;
    }

    if (MediaQuery.of(context).size.height <= 835) {
      return 0.55;
    }

    if (MediaQuery.of(context).size.height <= 880) {
      return 0.585;
    }

    if (MediaQuery.of(context).size.height <= 920) {
      return 0.6;
    }

    if (MediaQuery.of(context).size.height <= 950) {
      return 0.62;
    }

    if (devicePixelRatio <= 2.2) {
      return 0.48;
    }
    if (devicePixelRatio >= 2.2 && devicePixelRatio < 3) {
      return 0.6;
    }
    if (devicePixelRatio >= 3) {
      return 0.565;
    }

    return 0.565;
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final baseCurrency = sSignalRModules.baseCurrency;
    final currencies = sSignalRModules.currenciesList;
    final marketItems = sSignalRModules.marketItems;
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);
    final currenciesList = currencies.toList();
    sortCurrenciesMyAssets(currenciesList);

    return PortfolioScreenGradient(
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white10,
                pinned: true,
                stretch: true,
                elevation: 0,
                expandedHeight:
                    MediaQuery.of(context).size.height <= 830 ? 269 : 240,
                collapsedHeight: 116,
                floating: true,
                flexibleSpace: PortfolioSliverAppBar(
                  shrinkOffset: _offset,
                  max: getMaxChildSize(),
                  min: getMinChildSize(),
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            maxChildSize: getMaxChildSize(),
            minChildSize: getMinChildSize(),
            initialChildSize: getMinChildSize(),
            controller: controller,
            snap: true,
            builder: (context, sCon) {
              gCon = sCon;

              return DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  color: Colors.white,
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  controller: sCon,
                  physics: const ClampingScrollPhysics(),
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH30(),
                    SPaddingH24(
                      child: Row(
                        children: [
                          Text(
                            intl.portfolioWithBalanceBody_my_assets,
                            style: sTextH4Style,
                          ),
                          const Spacer(),
                          SIconButton(
                            onTap: () {
                              showHideZero(context);
                            },
                            defaultIcon: const SSettingsIcon(),
                            pressedIcon: SSettingsIcon(
                              color: colors.grey2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceH12(),
                    Observer(
                      builder: (context) {
                        print(getIt<AppStore>().isBalanceHide);

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
                                SWalletItem(
                                  key: UniqueKey(),
                                  isBalanceHide:
                                      getIt<AppStore>().isBalanceHide,
                                  decline:
                                      actualItem.dayPercentChange.isNegative,
                                  icon: SNetworkSvg24(url: actualItem.iconUrl),
                                  baseCurrPrefix: baseCurrency.prefix,
                                  primaryText: actualItem.description,
                                  amount: actualItem
                                      .volumeBaseBalance(baseCurrency),
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
                                  removeDivider: actualItem.isPendingDeposit ||
                                      index == itemsWithBalance.length - 1,
                                  isPendingDeposit: actualItem.isPendingDeposit,
                                ),
                                if (actualItem.isPendingDeposit) ...[
                                  BalanceInProcess(
                                    text: getIt<AppStore>().isBalanceHide
                                        ? actualItem.symbol
                                        : _balanceInProgressText(actualItem),
                                    leadText: _balanceInProgressLeadText(
                                      actualItem,
                                    ),
                                    removeDivider: actualItem ==
                                        (getIt<AppStore>().showAllAssets
                                            ? currenciesList.last
                                            : itemsWithBalance.last),
                                    icon: _balanceInProgressIcon(
                                      actualItem,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
