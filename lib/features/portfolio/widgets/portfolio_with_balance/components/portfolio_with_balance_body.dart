import 'dart:async';

import 'package:charts/simple_chart.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/chart/model/chart_input.dart';
import 'package:jetwallet/features/chart/model/chart_state.dart';
import 'package:jetwallet/features/chart/model/chart_union.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/chart/ui/balance_chart.dart';
import 'package:jetwallet/features/market/market_details/helper/period_change.dart';
import 'package:jetwallet/features/market/ui/widgets/fade_on_scroll.dart';
import 'package:jetwallet/features/pin_screen/model/pin_box_enum.dart';
import 'package:jetwallet/features/pin_screen/ui/widgets/pin_box.dart';
import 'package:jetwallet/features/portfolio/helper/currencies_without_balance_from.dart';
import 'package:jetwallet/features/portfolio/helper/market_currencies_indices.dart';
import 'package:jetwallet/features/portfolio/helper/market_fiats.dart';
import 'package:jetwallet/features/portfolio/helper/zero_balance_wallets_empty.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/actual_in_progress_operation.dart';
import 'package:jetwallet/utils/helpers/are_balances_empty.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/market_crypto.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import '../../portfolio_header.dart';
import 'balance_in_process.dart';
import 'padding_l_24.dart';
import 'portfolio_divider.dart';

class PortfolioWithBalanceBody extends StatelessWidget {
  const PortfolioWithBalanceBody({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ChartStore>(
          create: (_) => ChartStore(
            ChartInput(
              creationDate: sSignalRModules.clientDetail.walletCreationDate,
            ),
          ),
        ),
      ],
      builder: (context, child) => _PortfolioWithBalanceBody(
        tabController: tabController,
      ),
    );
  }
}

class _PortfolioWithBalanceBody extends StatefulObserverWidget {
  const _PortfolioWithBalanceBody({
    required this.tabController,
  });

  final TabController tabController;

  @override
  State<_PortfolioWithBalanceBody> createState() =>
      __PortfolioWithBalanceBodyState();
}

class __PortfolioWithBalanceBodyState extends State<_PortfolioWithBalanceBody> {
  bool showZeroBalanceWallets = false;

  int tabIndex = 0;

  late Timer updateTimer;

  @override
  void initState() {
    tabIndex = widget.tabController.index;

    widget.tabController.addListener(updateTabIndex);

    updateTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (getIt<AppRouter>().topRoute.name == 'PortfolioRouter') {
          ChartStore.of(context).fetchBalanceCandles(
            ChartStore.of(context).resolution,
            isLocal: true,
          );
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    widget.tabController.removeListener(updateTabIndex);

    updateTimer.cancel();
    super.dispose();
  }

  void updateTabIndex() {
    setState(() {
      tabIndex = widget.tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;
    final marketItems = sSignalRModules.marketItems;
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);
    final itemsWithoutBalance = currenciesWithoutBalanceFrom(currencies);
    final cryptosWithBalance = currenciesWithBalanceFrom(
      getMarketCrypto(sSignalRModules.currenciesList),
    );
    final cryptosWithoutBalance = currenciesWithoutBalanceFrom(
      getMarketCrypto(sSignalRModules.currenciesList),
    );
    final indicesWithBalance = currenciesWithBalanceFrom(
      getMarketCurrencies(sSignalRModules.currenciesList),
    );
    final indicesWithoutBalance = currenciesWithoutBalanceFrom(
      getMarketCurrencies(sSignalRModules.currenciesList),
    );
    final fiatsWithBalance = currenciesWithBalanceFrom(
      getMarketFiats(sSignalRModules.currenciesList),
    );
    final fiatsWithoutBalance = currenciesWithoutBalanceFrom(
      getMarketFiats(sSignalRModules.currenciesList),
    );

    final clientDetail = sSignalRModules.clientDetail;

    final baseCurrency = sSignalRModules.baseCurrency;

    final chart = ChartStore.of(context);

    final periodChange = _periodChange(
      ChartState(
        selectedCandle: chart.selectedCandle,
        candles: chart.candles,
        type: chart.type,
        resolution: chart.resolution,
        union: chart.union,
      ),
      baseCurrency,
    );

    final periodChangeColor =
        (periodChange[0].contains('-') || periodChange[1].contains('-'))
            ? colors.red
            : colors.green;

    final currentCandles = chart.candles[chart.resolution];
    final isCurrentCandlesEmptyOrNull =
        currentCandles == null || currentCandles.isEmpty;
    final balancesEmpty = areBalancesEmpty(currencies);

    final scrollController = ScrollController();

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
          '',
          intl.portfolioWithBalanceBody_simplex,
        );
      }

      return '${counterOfOperationInProgressTransactions(currency)} ';
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

    final isCryptoVisible = cryptosWithBalance.isNotEmpty &&
        (indicesWithBalance.isNotEmpty || fiatsWithBalance.isNotEmpty);
    final isFiatVisible = fiatsWithBalance.isNotEmpty &&
        (indicesWithBalance.isNotEmpty || cryptosWithBalance.isNotEmpty);
    final isIndicesVisible = indicesWithBalance.isNotEmpty &&
        (fiatsWithBalance.isNotEmpty || cryptosWithBalance.isNotEmpty);

    final isBalanceHideAndChartNotSelected = getIt<AppStore>().isBalanceHide;

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          backgroundColor: colors.white,
          pinned: true,
          stretch: true,
          elevation: 0,
          expandedHeight: 120,
          collapsedHeight: 120,
          automaticallyImplyLeading: false,
          primary: false,
          flexibleSpace: FadeOnScroll(
            scrollController: scrollController,
            fullOpacityOffset: 1,
            fadeInWidget: PortfolioHeader(
              showPrice: true,
              price: _price(
                ChartState(
                  selectedCandle: chart.selectedCandle,
                  candles: chart.candles,
                  type: chart.type,
                  resolution: chart.resolution,
                  union: chart.union,
                ),
                itemsWithBalance,
                baseCurrency,
              ),
            ),
            fadeOutWidget: const PortfolioHeader(),
            permanentWidget: const SizedBox(),
          ),
        ),
        SliverToBoxAdapter(
          child: Stack(
            children: [
              if (chart.union != const ChartUnion.loading()) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: SizedBox(
                    width: double.infinity,
                    height: 280,
                    child: SvgPicture.asset(
                      periodChange.contains('-')
                          ? redPortfolioImageAsset
                          : greenPortfolioImageAsset,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
              if (chart.union == const ChartUnion.loading() ||
                  isCurrentCandlesEmptyOrNull) ...[
                Container(
                  width: double.infinity,
                  height: 280,
                  color: colors.grey5,
                ),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (chart.union != const ChartUnion.loading()) ...[
                    Container(
                      height: 80,
                      color: colors.white,
                      child: PaddingL24(
                        child: Column(
                          children: [
                            if (!balancesEmpty)
                              SizedBox(
                                height: 45,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isBalanceHideAndChartNotSelected) ...[
                                      for (int i = 0; i < 6; i++)
                                        const PinBox(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          state: PinBoxEnum.filled,
                                        ),
                                      const SpaceW8(),
                                      GestureDetector(
                                        onTap: () {
                                          getIt<AppStore>()
                                              .setIsBalanceHide(false);
                                        },
                                        child: const SEyeCloseIcon(),
                                      ),
                                    ] else ...[
                                      Text(
                                        _price(
                                          ChartState(
                                            selectedCandle:
                                                chart.selectedCandle,
                                            candles: chart.candles,
                                            type: chart.type,
                                            resolution: chart.resolution,
                                            union: chart.union,
                                          ),
                                          itemsWithBalance,
                                          baseCurrency,
                                        ),
                                        style: sTextH1Style,
                                      ),
                                      const SpaceW8(),
                                      GestureDetector(
                                        onTap: () {
                                          getIt<AppStore>()
                                              .setIsBalanceHide(true);
                                        },
                                        child: SEyeOpenIcon(
                                          color: colors.black,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            if (!balancesEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!isBalanceHideAndChartNotSelected) ...[
                                    Text(
                                      periodChange[0],
                                      style: sSubtitle3Style.copyWith(
                                        color: periodChangeColor,
                                      ),
                                    ),
                                  ],
                                  Text(
                                    periodChange[1],
                                    style: sSubtitle3Style.copyWith(
                                      color: periodChangeColor,
                                    ),
                                  ),
                                  const SpaceW10(),
                                  if (!isCurrentCandlesEmptyOrNull)
                                    if (periodChange[1].isNotEmpty)
                                      Text(
                                        _chartResolution(
                                          chart.resolution,
                                          context,
                                        ),
                                        style: sBodyText2Style.copyWith(
                                          color: colors.grey3,
                                        ),
                                      ),
                                ],
                              ),
                            if (balancesEmpty)
                              Row(
                                children: [
                                  Text(
                                    '${intl.portfolioWith_balanceProcess}...',
                                    style: sTextH1Style.copyWith(
                                      color: colors.black,
                                    ),
                                  ),
                                  const SpaceH60(),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (chart.union == const ChartUnion.loading()) ...[
                    Container(
                      height: 80,
                      width: double.infinity,
                      color: colors.grey5,
                      child: const PaddingL24(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SpaceH13(),
                            SSkeletonTextLoader(height: 24, width: 152),
                            SpaceH13(),
                            SSkeletonTextLoader(height: 16, width: 80),
                            SpaceH14(),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (!balancesEmpty &&
                      clientDetail.walletCreationDate.isNotEmpty) ...[
                    BalanceChart(
                      onCandleSelected: (ChartInfoModel? chartInfo) {
                        chart.updateSelectedCandle(chartInfo?.right);
                      },
                      walletCreationDate: clientDetail.walletCreationDate,
                    ),
                  ],
                  if (balancesEmpty &&
                      clientDetail.walletCreationDate.isEmpty) ...[
                    Container(
                      height: 176,
                    ),
                  ],
                  Container(
                    padding: const EdgeInsets.only(
                      top: 36,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      color: colors.white,
                    ),
                    child: SPaddingH24(
                      child: Row(
                        children: [
                          Text(
                            intl.portfolioWithBalanceBody_portfolio,
                            style: sTextH4Style,
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (tabIndex == 1) {
                                sRouter.push(
                                  TransactionHistoryRouter(
                                    initialIndex: 2,
                                  ),
                                );
                              } else {
                                sRouter.push(
                                  TransactionHistoryRouter(),
                                );
                              }
                            },
                            child: const SIndexHistoryIcon(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: colors.white,
                    height: 15,
                  ),
                  Container(
                    color: colors.white,
                    height: _walletsListHeight(
                      currentTabIndex: tabIndex,
                      showZeroBalanceWallets: showZeroBalanceWallets,
                      itemsWithBalance: itemsWithBalance,
                      itemsWithoutBalance: itemsWithoutBalance,
                      cryptosWithBalance: cryptosWithBalance,
                      cryptosWithoutBalance: cryptosWithoutBalance,
                      indicesWithBalance: indicesWithBalance,
                      indicesWithoutBalance: indicesWithoutBalance,
                      fiatsWithBalance: fiatsWithBalance,
                      fiatsWithoutBalance: fiatsWithoutBalance,
                    ),
                    child: TabBarView(
                      controller: widget.tabController,
                      children: [
                        ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            for (final item in itemsWithBalance) ...[
                              SWalletItem(
                                isBalanceHide: getIt<AppStore>().isBalanceHide,
                                decline: item.dayPercentChange.isNegative,
                                icon: SNetworkSvg24(
                                  url: item.iconUrl,
                                ),
                                primaryText: item.description,
                                amount: item.volumeBaseBalance(baseCurrency),
                                secondaryText: getIt<AppStore>().isBalanceHide
                                    ? item.symbol
                                    : item.volumeAssetBalance,
                                onTap: () {
                                  if (item.type == AssetType.indices) {
                                    sRouter.push(
                                      MarketDetailsRouter(
                                        marketItem: marketItemFrom(
                                          marketItems,
                                          item.symbol,
                                        ),
                                      ),
                                    );
                                  } else {
                                    navigateToWallet(context, item);
                                  }
                                },
                                removeDivider: item.isPendingDeposit ||
                                    item == itemsWithBalance.last,
                                isPendingDeposit: item.isPendingDeposit,
                              ),
                              if (item.isPendingDeposit) ...[
                                BalanceInProcess(
                                  text: getIt<AppStore>().isBalanceHide
                                      ? item.symbol
                                      : _balanceInProgressText(item),
                                  leadText: _balanceInProgressLeadText(item),
                                  removeDivider: item == itemsWithBalance.last,
                                  icon: _balanceInProgressIcon(item),
                                ),
                              ],
                            ],
                            if (showZeroBalanceWallets) ...[
                              const PortfolioDivider(),
                              for (final item in itemsWithoutBalance)
                                SWalletItem(
                                  decline: item.dayPercentChange.isNegative,
                                  icon: SNetworkSvg24(
                                    url: item.iconUrl,
                                  ),
                                  primaryText: item.description,
                                  amount: item.volumeBaseBalance(baseCurrency),
                                  secondaryText: item.volumeAssetBalance,
                                  onTap: () {
                                    if (item.type == AssetType.indices) {
                                      sRouter.push(
                                        MarketDetailsRouter(
                                          marketItem: marketItemFrom(
                                            marketItems,
                                            item.symbol,
                                          ),
                                        ),
                                      );
                                    } else {
                                      navigateToWallet(context, item);
                                    }
                                  },
                                  color: colors.black,
                                  removeDivider:
                                      item == itemsWithoutBalance.last,
                                  isPendingDeposit: item.isPendingDeposit,
                                ),
                            ],
                            if (!zeroBalanceWalletsEmpty(itemsWithoutBalance))
                              Padding(
                                padding: EdgeInsets.only(
                                  top: showZeroBalanceWallets ? 10 : 27.5,
                                ),
                                child: Center(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () => setState(() {
                                      showZeroBalanceWallets =
                                          !showZeroBalanceWallets;
                                    }),
                                    child: Text(
                                      showZeroBalanceWallets
                                          ? intl.portfolioWith_zeroWallets
                                          : intl.portfolioWith_showWallets,
                                      style: sBodyText2Style,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (isCryptoVisible)
                          ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              for (final item in cryptosWithBalance) ...[
                                SWalletItem(
                                  decline: item.dayPercentChange.isNegative,
                                  icon: SNetworkSvg24(
                                    url: item.iconUrl,
                                  ),
                                  primaryText: item.description,
                                  amount: item.volumeBaseBalance(baseCurrency),
                                  secondaryText: item.volumeAssetBalance,
                                  onTap: () => navigateToWallet(context, item),
                                  removeDivider: item.isPendingDeposit ||
                                      item == cryptosWithBalance.last,
                                  isPendingDeposit: item.isPendingDeposit,
                                ),
                                if (item.isPendingDeposit) ...[
                                  BalanceInProcess(
                                    text: _balanceInProgressText(item),
                                    leadText: _balanceInProgressLeadText(item),
                                    removeDivider:
                                        item == cryptosWithBalance.last,
                                    icon: _balanceInProgressIcon(item),
                                  ),
                                ],
                              ],
                              if (showZeroBalanceWallets) ...[
                                const PortfolioDivider(),
                                for (final item in cryptosWithoutBalance) ...[
                                  SWalletItem(
                                    decline: item.dayPercentChange.isNegative,
                                    icon: SNetworkSvg24(
                                      url: item.iconUrl,
                                    ),
                                    primaryText: item.description,
                                    amount:
                                        item.volumeBaseBalance(baseCurrency),
                                    secondaryText: item.volumeAssetBalance,
                                    onTap: () =>
                                        navigateToWallet(context, item),
                                    color: colors.black,
                                    removeDivider:
                                        item == cryptosWithoutBalance.last,
                                    isPendingDeposit: item.isPendingDeposit,
                                  ),
                                ],
                              ],
                              if (!zeroBalanceWalletsEmpty(itemsWithoutBalance))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 27.5,
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () => setState(() {
                                        showZeroBalanceWallets =
                                            !showZeroBalanceWallets;
                                      }),
                                      child: Text(
                                        showZeroBalanceWallets
                                            ? intl.portfolioWith_zeroWallets
                                            : intl.portfolioWith_showWallets,
                                        style: sBodyText2Style,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        if (isIndicesVisible)
                          ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              for (final item in indicesWithBalance) ...[
                                SWalletItem(
                                  decline: item.dayPercentChange.isNegative,
                                  icon: SNetworkSvg24(
                                    url: item.iconUrl,
                                  ),
                                  primaryText: item.description,
                                  amount: item.volumeBaseBalance(baseCurrency),
                                  secondaryText:
                                      '${item.assetBalance} ${item.symbol}',
                                  onTap: () {
                                    sRouter.push(
                                      MarketDetailsRouter(
                                        marketItem: marketItemFrom(
                                          marketItems,
                                          item.symbol,
                                        ),
                                      ),
                                    );
                                  },
                                  removeDivider: item.isPendingDeposit ||
                                      item == indicesWithBalance.last,
                                  isPendingDeposit: item.isPendingDeposit,
                                ),
                                if (item.isPendingDeposit) ...[
                                  BalanceInProcess(
                                    text: _balanceInProgressText(item),
                                    leadText: _balanceInProgressLeadText(item),
                                    removeDivider:
                                        item == indicesWithBalance.last,
                                    icon: _balanceInProgressIcon(item),
                                  ),
                                ],
                              ],
                              if (showZeroBalanceWallets) ...[
                                const PortfolioDivider(),
                                for (final item in indicesWithoutBalance)
                                  SWalletItem(
                                    decline: item.dayPercentChange.isNegative,
                                    icon: SNetworkSvg24(
                                      url: item.iconUrl,
                                    ),
                                    primaryText: item.description,
                                    amount:
                                        item.volumeBaseBalance(baseCurrency),
                                    secondaryText: item.volumeAssetBalance,
                                    onTap: () {
                                      sRouter.push(
                                        MarketDetailsRouter(
                                          marketItem: marketItemFrom(
                                            marketItems,
                                            item.symbol,
                                          ),
                                        ),
                                      );
                                    },
                                    color: colors.black,
                                    removeDivider:
                                        item == indicesWithoutBalance.last,
                                    isPendingDeposit: item.isPendingDeposit,
                                  ),
                              ],
                              if (!zeroBalanceWalletsEmpty(
                                indicesWithoutBalance,
                              ))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 27.5,
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () => setState(() {
                                        showZeroBalanceWallets =
                                            !showZeroBalanceWallets;
                                      }),
                                      child: Text(
                                        showZeroBalanceWallets
                                            ? intl.portfolioWith_zeroWallets
                                            : intl.portfolioWith_showWallets,
                                        style: sBodyText2Style,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        if (isFiatVisible)
                          ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              for (final item in fiatsWithBalance) ...[
                                SWalletItem(
                                  decline: item.dayPercentChange.isNegative,
                                  icon: SNetworkSvg24(
                                    url: item.iconUrl,
                                  ),
                                  primaryText: item.description,
                                  amount: item.volumeBaseBalance(baseCurrency),
                                  secondaryText: item.volumeAssetBalance,
                                  onTap: () => navigateToWallet(context, item),
                                  removeDivider: item.isPendingDeposit ||
                                      item == fiatsWithBalance.last,
                                  isPendingDeposit: item.isPendingDeposit,
                                ),
                                if (item.isPendingDeposit) ...[
                                  BalanceInProcess(
                                    text: _balanceInProgressText(item),
                                    leadText: _balanceInProgressLeadText(item),
                                    removeDivider:
                                        item == fiatsWithBalance.last,
                                    icon: _balanceInProgressIcon(item),
                                  ),
                                ],
                              ],
                              if (showZeroBalanceWallets) ...[
                                const PortfolioDivider(),
                                for (final item in fiatsWithoutBalance)
                                  SWalletItem(
                                    decline: item.dayPercentChange.isNegative,
                                    icon: SNetworkSvg24(
                                      url: item.iconUrl,
                                    ),
                                    primaryText: item.description,
                                    amount:
                                        item.volumeBaseBalance(baseCurrency),
                                    secondaryText: item.volumeAssetBalance,
                                    onTap: () =>
                                        navigateToWallet(context, item),
                                    color: colors.black,
                                    removeDivider:
                                        item == fiatsWithoutBalance.last,
                                    isPendingDeposit: item.isPendingDeposit,
                                  ),
                              ],
                              if (!zeroBalanceWalletsEmpty(fiatsWithoutBalance))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 27.5,
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () => setState(() {
                                        showZeroBalanceWallets =
                                            !showZeroBalanceWallets;
                                      }),
                                      child: Text(
                                        showZeroBalanceWallets
                                            ? intl.portfolioWith_zeroWallets
                                            : intl.portfolioWith_showWallets,
                                        style: sBodyText2Style,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _chartResolution(
    String resolution,
    BuildContext context,
  ) {
    if (resolution == Period.week) {
      return intl.portfolioWithBalanceBody_week;
    }
    if (resolution == Period.month) {
      return intl.portfolioWithBalanceBody_month;
    }
    if (resolution == Period.all) {
      return intl.portfolioWithBalanceBody_all;
    }

    return intl.portfolioWithBalanceBody_today;
  }

  String _price(
    ChartState chart,
    List<CurrencyModel> items,
    BaseCurrencyModel baseCurrency,
  ) {
    var totalBalance = Decimal.zero;

    for (final item in items) {
      totalBalance += item.baseBalance;
    }

    return chart.selectedCandle != null
        ? marketFormat(
            prefix: baseCurrency.prefix,
            decimal: Decimal.parse(chart.selectedCandle!.close.toString()),
            accuracy: baseCurrency.accuracy,
            symbol: baseCurrency.symbol,
          )
        : marketFormat(
            prefix: baseCurrency.prefix,
            decimal: totalBalance,
            accuracy: baseCurrency.accuracy,
            symbol: baseCurrency.symbol,
          );
  }

  List<String> _periodChange(
    ChartState chart,
    BaseCurrencyModel baseCurrency,
  ) {
    return chart.selectedCandle != null
        ? periodChange(
            chart: chart,
            selectedCandle: chart.selectedCandle,
            baseCurrency: baseCurrency,
          )
        : periodChange(chart: chart, baseCurrency: baseCurrency);
  }

  // TODO: refactor
  double? _walletsListHeight({
    required int currentTabIndex,
    required bool showZeroBalanceWallets,
    required List<CurrencyModel> itemsWithBalance,
    required List<CurrencyModel> itemsWithoutBalance,
    required List<CurrencyModel> cryptosWithBalance,
    required List<CurrencyModel> cryptosWithoutBalance,
    required List<CurrencyModel> indicesWithBalance,
    required List<CurrencyModel> indicesWithoutBalance,
    required List<CurrencyModel> fiatsWithBalance,
    required List<CurrencyModel> fiatsWithoutBalance,
  }) {
    const walletHeight = 88.0;
    const showWalletsButtonHeight = 70.0;
    const depositInProccessHeight = 54.0;

    final itemsWithBalanceLength = itemsWithBalance.length;
    final itemsWithoutBalanceLength = itemsWithoutBalance.length;
    final cryptosWithBalanceLength = cryptosWithBalance.length;
    final cryptosWithoutBalanceLength = cryptosWithoutBalance.length;
    final indicesWithBalanceLength = indicesWithBalance.length;
    final indicesWithoutBalanceLength = indicesWithoutBalance.length;
    final fiatsWithBalanceLength = fiatsWithBalance.length;
    final fiatsWithoutBalanceLength = fiatsWithoutBalance.length;

    if (currentTabIndex == 0) {
      final total = walletHeight *
              (itemsWithBalanceLength +
                  (showZeroBalanceWallets ? itemsWithoutBalanceLength : 0)) +
          showWalletsButtonHeight;

      var depositInProccess = 0;

      for (final item in itemsWithBalance) {
        if (item.totalAmountInProcess != Decimal.zero) {
          depositInProccess++;
        }
      }

      if (showZeroBalanceWallets) {
        for (final item in itemsWithoutBalance) {
          if (item.totalAmountInProcess != Decimal.zero) {
            depositInProccess++;
          }
        }
      }

      final totalDepositInProccessHeight =
          depositInProccessHeight * depositInProccess;

      return total + totalDepositInProccessHeight;
    } else if (currentTabIndex == 1) {
      final total = walletHeight *
              (cryptosWithBalanceLength +
                  (showZeroBalanceWallets ? cryptosWithoutBalanceLength : 0)) +
          showWalletsButtonHeight;

      var depositInProccess = 0;

      for (final item in cryptosWithBalance) {
        if (item.totalAmountInProcess != Decimal.zero) {
          depositInProccess++;
        }
      }

      if (showZeroBalanceWallets) {
        for (final item in cryptosWithoutBalance) {
          if (item.totalAmountInProcess != Decimal.zero) {
            depositInProccess++;
          }
        }
      }

      final totalDepositInProccessHeight =
          depositInProccessHeight * depositInProccess;

      return total + totalDepositInProccessHeight;
    } else if (currentTabIndex == 2) {
      final total = walletHeight *
              (indicesWithBalanceLength +
                  (showZeroBalanceWallets ? indicesWithoutBalanceLength : 0)) +
          showWalletsButtonHeight;

      var depositInProccess = 0;

      for (final item in indicesWithBalance) {
        if (item.totalAmountInProcess != Decimal.zero) {
          depositInProccess++;
        }
      }

      if (showZeroBalanceWallets) {
        for (final item in indicesWithoutBalance) {
          if (item.totalAmountInProcess != Decimal.zero) {
            depositInProccess++;
          }
        }
      }

      final totalDepositInProccessHeight =
          depositInProccessHeight * depositInProccess;

      return total + totalDepositInProccessHeight;
    } else {
      final total = walletHeight *
              (fiatsWithBalanceLength +
                  (showZeroBalanceWallets ? fiatsWithoutBalanceLength : 0)) +
          showWalletsButtonHeight;

      var depositInProccess = 0;

      for (final item in fiatsWithBalance) {
        if (item.totalAmountInProcess != Decimal.zero) {
          depositInProccess++;
        }
      }

      if (showZeroBalanceWallets) {
        for (final item in fiatsWithoutBalance) {
          if (item.totalAmountInProcess != Decimal.zero) {
            depositInProccess++;
          }
        }
      }

      final totalDepositInProccessHeight =
          depositInProccessHeight * depositInProccess;

      return total + totalDepositInProccessHeight;
    }
  }
}
