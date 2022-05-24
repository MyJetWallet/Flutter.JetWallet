import 'package:charts/simple_chart.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/asset_model.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../../shared/helpers/currencies_with_balance_from.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/features/chart/notifier/balance_chart_input_stpod.dart';
import '../../../../../../shared/features/chart/notifier/chart_notipod.dart';
import '../../../../../../shared/features/chart/notifier/chart_state.dart';
import '../../../../../../shared/features/chart/notifier/chart_union.dart';
import '../../../../../../shared/features/chart/view/balance_chart.dart';
import '../../../../../../shared/features/market_details/helper/period_change.dart';
import '../../../../../../shared/features/market_details/view/market_details.dart';
import '../../../../../../shared/features/recurring/notifier/recurring_buys_notipod.dart';
import '../../../../../../shared/features/transaction_history/view/transaction_hisotry.dart';
import '../../../../../../shared/features/wallet/helper/market_item_from.dart';
import '../../../../../../shared/features/wallet/helper/navigate_to_wallet.dart';
import '../../../../../../shared/helpers/are_balances_empty.dart';
import '../../../../../../shared/helpers/formatting/base/market_format.dart';
import '../../../../../../shared/helpers/formatting/base/volume_format.dart';
import '../../../../../../shared/models/currency_model.dart';
import '../../../../../../shared/providers/base_currency_pod/base_currency_model.dart';
import '../../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../../shared/providers/client_detail_pod/client_detail_pod.dart';
import '../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../../../../market/provider/market_crypto_pod.dart';
import '../../../../../market/provider/market_currencies_indices_pod.dart';
import '../../../../../market/provider/market_fiats_pod.dart';
import '../../../../../market/provider/market_items_pod.dart';
import '../../../../helper/currencies_without_balance_from.dart';
import '../../../../helper/zero_balance_wallets_empty.dart';
import '../../../../provider/show_zero_balance_wallets_stpod.dart';
import 'balance_in_process.dart';
import 'padding_l_24.dart';
import 'portfolio_divider.dart';

// TODO: refactor
class PortfolioWithBalanceBody extends HookWidget {
  const PortfolioWithBalanceBody({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);
    final marketItems = useProvider(marketItemsPod);
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);
    final itemsWithoutBalance = currenciesWithoutBalanceFrom(currencies);
    final cryptosWithBalance = currenciesWithBalanceFrom(
      useProvider(marketCryptoPod),
    );
    final cryptosWithoutBalance = currenciesWithoutBalanceFrom(
      useProvider(marketCryptoPod),
    );
    final indicesWithBalance = currenciesWithBalanceFrom(
      useProvider(marketCurrenciesIndicesPod),
    );
    final indicesWithoutBalance = currenciesWithoutBalanceFrom(
      useProvider(marketCurrenciesIndicesPod),
    );
    final fiatsWithBalance = currenciesWithBalanceFrom(
      useProvider(marketFiatsPod),
    );
    final fiatsWithoutBalance = currenciesWithoutBalanceFrom(
      useProvider(marketFiatsPod),
    );
    final clientDetail = useProvider(clientDetailPod);
    final chartN = useProvider(
      chartNotipod(
        useProvider(balanceChartInputStpod).state,
      ).notifier,
    );
    final chart = useProvider(
      chartNotipod(
        useProvider(balanceChartInputStpod).state,
      ),
    );
    final showZeroBalanceWallets = useProvider(showZeroBalanceWalletsStpod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final periodChange = _periodChange(chart, baseCurrency);
    final periodChangeColor =
        periodChange.contains('-') ? colors.red : colors.green;
    final currentCandles = chart.candles[chart.resolution];
    final isCurrentCandlesEmptyOrNull =
        currentCandles == null || currentCandles.isEmpty;
    final balancesEmpty = areBalancesEmpty(currencies);

    final notifier = useProvider(recurringBuysNotipod.notifier);

    return SingleChildScrollView(
      child: Stack(
        children: [
          if (chart.union != const ChartUnion.loading())
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: SizedBox(
                width: double.infinity,
                height: 465,
                child: SvgPicture.asset(
                  periodChange.contains('-')
                      ? redPortfolioImageAsset
                      : greenPortfolioImageAsset,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          if (chart.union == const ChartUnion.loading() ||
              isCurrentCandlesEmptyOrNull)
            Container(
              width: double.infinity,
              height: 465,
              color: colors.grey5,
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (chart.union != const ChartUnion.loading())
                Container(
                  height: 104,
                  color: colors.white,
                  child: PaddingL24(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!balancesEmpty)
                          Text(
                            _price(
                              chart,
                              itemsWithBalance,
                              baseCurrency,
                            ),
                            style: sTextH1Style,
                          ),
                        if (!balancesEmpty)
                          Row(
                            children: [
                              Text(
                                periodChange,
                                style: sSubtitle3Style.copyWith(
                                  color: periodChangeColor,
                                ),
                              ),
                              const SpaceW10(),
                              if (!isCurrentCandlesEmptyOrNull)
                                Text(
                                  _chartResolution(chart.resolution, context),
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
              if (chart.union == const ChartUnion.loading())
                Container(
                  height: 104,
                  width: double.infinity,
                  color: colors.grey5,
                  child: PaddingL24(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SpaceH13(),
                        SSkeletonTextLoader(height: 24, width: 152),
                        SpaceH13(),
                        SSkeletonTextLoader(height: 16, width: 80),
                        SpaceH38(),
                      ],
                    ),
                  ),
                ),
              if (!balancesEmpty)
                BalanceChart(
                  onCandleSelected: (ChartInfoModel? chartInfo) {
                    chartN.updateSelectedCandle(chartInfo?.right);
                  },
                  walletCreationDate: clientDetail.walletCreationDate,
                ),
              if (balancesEmpty)
                Container(
                  height: 296,
                ),
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
                          TransactionHistory.push(
                            context: context,
                          );
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
                  currentTabIndex: tabController.index,
                  showZeroBalanceWallets: showZeroBalanceWallets.state,
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
                  controller: tabController,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        for (final item in itemsWithBalance) ...[
                          SWalletItem(
                            decline: item.dayPercentChange.isNegative,
                            icon: SNetworkSvg24(
                              url: item.iconUrl,
                            ),
                            isRecurring:
                                notifier.activeOrPausedType(item.symbol),
                            primaryText: item.description,
                            amount: item.volumeBaseBalance(baseCurrency),
                            secondaryText: item.volumeAssetBalance,
                            onTap: () {
                              if (item.type == AssetType.indices) {
                                navigatorPush(
                                  context,
                                  MarketDetails(
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
                              text: '${intl.portfolioWithBalanceBody_deposit}'
                                  ' ${volumeFormat(
                                decimal: item.depositInProcess,
                                accuracy: item.accuracy,
                                symbol: item.symbol,
                                prefix: item.prefixSymbol,
                              )}',
                              removeDivider: item == itemsWithBalance.last,
                            ),
                          ]
                        ],
                        if (showZeroBalanceWallets.state) ...[
                          const PortfolioDivider(),
                          for (final item in itemsWithoutBalance)
                            SWalletItem(
                              decline: item.dayPercentChange.isNegative,
                              icon: SNetworkSvg24(
                                url: item.iconUrl,
                              ),
                              isRecurring:
                                  notifier.activeOrPausedType(item.symbol),
                              primaryText: item.description,
                              amount: item.volumeBaseBalance(baseCurrency),
                              secondaryText: item.volumeAssetBalance,
                              onTap: () {
                                if (item.type == AssetType.indices) {
                                  navigatorPush(
                                    context,
                                    MarketDetails(
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
                              removeDivider: item == itemsWithoutBalance.last,
                              isPendingDeposit: item.isPendingDeposit,
                            ),
                        ],
                        if (!zeroBalanceWalletsEmpty(itemsWithoutBalance))
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 27.5,
                            ),
                            child: Center(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () => showZeroBalanceWallets.state =
                                    !showZeroBalanceWallets.state,
                                child: Text(
                                  showZeroBalanceWallets.state
                                      ? intl.portfolioWith_zeroWallets
                                      : intl.portfolioWith_showWallets,
                                  style: sBodyText2Style,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (cryptosWithBalance.isNotEmpty)
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
                              isRecurring:
                                  notifier.activeOrPausedType(item.symbol),
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
                                text: '${intl.portfolioWithBalanceBody_deposit}'
                                    ' ${volumeFormat(
                                  decimal: item.depositInProcess,
                                  accuracy: item.accuracy,
                                  symbol: item.symbol,
                                  prefix: item.prefixSymbol,
                                )}',
                                removeDivider: item == cryptosWithBalance.last,
                              ),
                            ]
                          ],
                          if (showZeroBalanceWallets.state) ...[
                            const PortfolioDivider(),
                            for (final item in cryptosWithoutBalance) ...[
                              SWalletItem(
                                decline: item.dayPercentChange.isNegative,
                                icon: SNetworkSvg24(
                                  url: item.iconUrl,
                                ),
                                primaryText: item.description,
                                amount: item.volumeBaseBalance(baseCurrency),
                                secondaryText: item.volumeAssetBalance,
                                onTap: () => navigateToWallet(context, item),
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
                                  onTap: () => showZeroBalanceWallets.state =
                                      !showZeroBalanceWallets.state,
                                  child: Text(
                                    showZeroBalanceWallets.state
                                        ? intl.portfolioWith_zeroWallets
                                        : intl
                                            .portfolioWith_showWallets,
                                    style: sBodyText2Style,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    if (indicesWithBalance.isNotEmpty)
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
                              isRecurring:
                                  notifier.activeOrPausedType(item.symbol),
                              primaryText: item.description,
                              amount: item.volumeBaseBalance(baseCurrency),
                              secondaryText:
                                  '${item.assetBalance} ${item.symbol}',
                              onTap: () {
                                navigatorPush(
                                  context,
                                  MarketDetails(
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
                                text: '${intl.portfolioWithBalanceBody_deposit}'
                                    ' ${volumeFormat(
                                  decimal: item.depositInProcess,
                                  accuracy: item.accuracy,
                                  symbol: item.symbol,
                                  prefix: item.prefixSymbol,
                                )}',
                                removeDivider: item == indicesWithBalance.last,
                              ),
                            ]
                          ],
                          if (showZeroBalanceWallets.state) ...[
                            const PortfolioDivider(),
                            for (final item in indicesWithoutBalance)
                              SWalletItem(
                                decline: item.dayPercentChange.isNegative,
                                icon: SNetworkSvg24(
                                  url: item.iconUrl,
                                ),
                                primaryText: item.description,
                                amount: item.volumeBaseBalance(baseCurrency),
                                secondaryText: item.volumeAssetBalance,
                                onTap: () {
                                  navigatorPush(
                                    context,
                                    MarketDetails(
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
                          if (!zeroBalanceWalletsEmpty(indicesWithoutBalance))
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 27.5,
                              ),
                              child: Center(
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () => showZeroBalanceWallets.state =
                                      !showZeroBalanceWallets.state,
                                  child: Text(
                                    showZeroBalanceWallets.state
                                        ? intl.portfolioWith_zeroWallets
                                        : intl.portfolioWith_showWallets,
                                    style: sBodyText2Style,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    if (fiatsWithBalance.isNotEmpty)
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
                              isRecurring:
                                  notifier.activeOrPausedType(item.symbol),
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
                                text: '${intl.portfolioWithBalanceBody_deposit}'
                                    ' ${volumeFormat(
                                  decimal: item.depositInProcess,
                                  accuracy: item.accuracy,
                                  symbol: item.symbol,
                                  prefix: item.prefixSymbol,
                                )}',
                                removeDivider: item == fiatsWithBalance.last,
                              ),
                            ]
                          ],
                          if (showZeroBalanceWallets.state) ...[
                            const PortfolioDivider(),
                            for (final item in fiatsWithoutBalance)
                              SWalletItem(
                                decline: item.dayPercentChange.isNegative,
                                icon: SNetworkSvg24(
                                  url: item.iconUrl,
                                ),
                                isRecurring:
                                    notifier.activeOrPausedType(item.symbol),
                                primaryText: item.description,
                                amount: item.volumeBaseBalance(baseCurrency),
                                secondaryText: item.volumeAssetBalance,
                                onTap: () => navigateToWallet(context, item),
                                color: colors.black,
                                removeDivider: item == fiatsWithoutBalance.last,
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
                                  onTap: () => showZeroBalanceWallets.state =
                                      !showZeroBalanceWallets.state,
                                  child: Text(
                                    showZeroBalanceWallets.state
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
          )
        ],
      ),
    );
  }

  String _chartResolution(
    String resolution,
    BuildContext context,
  ) {
    final intl = context.read(intlPod);

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

    if (chart.selectedCandle != null) {
      return marketFormat(
        prefix: baseCurrency.prefix,
        // TODO add decimals to ChartModel
        decimal: Decimal.parse(chart.selectedCandle!.close.toString()),
        accuracy: baseCurrency.accuracy,
        symbol: baseCurrency.symbol,
      );
    } else {
      return marketFormat(
        prefix: baseCurrency.prefix,
        decimal: totalBalance,
        accuracy: baseCurrency.accuracy,
        symbol: baseCurrency.symbol,
      );
    }
  }

  String _periodChange(
    ChartState chart,
    BaseCurrencyModel baseCurrency,
  ) {
    if (chart.selectedCandle != null) {
      return periodChange(
        chart: chart,
        selectedCandle: chart.selectedCandle,
        baseCurrency: baseCurrency,
      );
    } else {
      return periodChange(
        chart: chart,
        baseCurrency: baseCurrency,
      );
    }
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
        if (item.depositInProcess != Decimal.zero) {
          depositInProccess++;
        }
      }

      if (showZeroBalanceWallets) {
        for (final item in itemsWithoutBalance) {
          if (item.depositInProcess != Decimal.zero) {
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
        if (item.depositInProcess != Decimal.zero) {
          depositInProccess++;
        }
      }

      if (showZeroBalanceWallets) {
        for (final item in cryptosWithoutBalance) {
          if (item.depositInProcess != Decimal.zero) {
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
        if (item.depositInProcess != Decimal.zero) {
          depositInProccess++;
        }
      }

      if (showZeroBalanceWallets) {
        for (final item in indicesWithoutBalance) {
          if (item.depositInProcess != Decimal.zero) {
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
        if (item.depositInProcess != Decimal.zero) {
          depositInProccess++;
        }
      }

      if (showZeroBalanceWallets) {
        for (final item in fiatsWithoutBalance) {
          if (item.depositInProcess != Decimal.zero) {
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
