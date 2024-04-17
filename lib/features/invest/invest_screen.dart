import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/invest/stores/chart/invest_chart_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/dashboard/invest_header.dart';
import 'package:jetwallet/features/invest/ui/dashboard/my_portfolio.dart';
import 'package:jetwallet/features/invest/ui/dashboard/new_invest_header.dart';
import 'package:jetwallet/features/invest/ui/dashboard/sectors_block.dart';
import 'package:jetwallet/features/invest/ui/dashboard/symbol_info.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_carousel.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_favorites_bottom_sheet.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_list_bottom_sheet.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_market_watch_bottom_sheet.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_divider.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';

import '../../core/di/di.dart';
import '../../core/l10n/i10n.dart';
import '../../core/services/signal_r/signal_r_service_new.dart';
import '../../utils/helpers/currency_from.dart';

@RoutePage(name: 'InvestPageRouter')
class InvestScreen extends StatefulObserverWidget {
  const InvestScreen({super.key});

  @override
  State<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends State<InvestScreen> {
  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;
    final investStore = getIt.get<InvestDashboardStore>();
    final investPositionsStore = getIt.get<InvestPositionsStore>();
    final investChartStore = getIt.get<InvestChartStore>();

    final colors = sKit.colors;
    final currency = currencyFrom(currencies, 'USDT');

    int getGroupedLength(String symbol) {
      final groupedPositions = investPositionsStore.activeList.where(
        (element) => element.symbol == symbol,
      );

      return groupedPositions.length;
    }

    Decimal getGroupedProfit(String symbol) {
      final groupedPositions = investPositionsStore.activeList
          .where(
            (element) => element.symbol == symbol,
          )
          .toList();
      var profit = Decimal.zero;
      for (var i = 0; i < groupedPositions.length; i++) {
        profit += investStore.getProfitByPosition(groupedPositions[i]);
      }

      return profit;
    }

    return Material(
      color: colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SPaddingH24(
            child: InvestHeader(
              currency: currency,
            ),
          ),
          SPaddingH24(
            child: Observer(
              builder: (BuildContext context) {
                var amountSum = Decimal.zero;
                var profitSum = Decimal.zero;
                if (sSignalRModules.investPositionsData != null) {
                  final activePositions = sSignalRModules.investPositionsData!.positions
                      .where(
                        (element) => element.status == PositionStatus.opened,
                      )
                      .toList();
                  for (var i = 0; i < activePositions.length; i++) {
                    amountSum += activePositions[i].amount!;
                    profitSum += investStore.getProfitByPosition(activePositions[i]);
                  }
                }

                final percentage = (amountSum == Decimal.zero || profitSum == Decimal.zero)
                    ? Decimal.zero
                    : Decimal.fromJson('${(Decimal.fromInt(100) * profitSum / amountSum).toDouble()}');

                return MyPortfolio(
                  pending: investStore.totalPendingAmount,
                  amount: amountSum,
                  balance: profitSum,
                  percent: percentage,
                  onShare: () {},
                  currency: currency,
                  title: intl.invest_my_portfolio,
                  onTap: () {
                    showInvestListBottomSheet(context);
                  },
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                const SPaddingH24(
                  child: SDivider(),
                ),
                Observer(
                  builder: (context) {
                    if (investPositionsStore.activeList.isEmpty) {
                      return const SizedBox();
                    }

                    return Container(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      decoration: BoxDecoration(
                        color: colors.grey5,
                      ),
                      child: Column(
                        children: [
                          SPaddingH24(
                            child: NewInvestHeader(
                              showRollover: false,
                              showModify: false,
                              showIcon: true,
                              showFull: false,
                              title: intl.invest_my_invest,
                              haveActiveInvest: true,
                              onButtonTap: () {
                                showInvestListBottomSheet(context);
                              },
                            ),
                          ),
                          const SpaceH4(),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Observer(
                              builder: (BuildContext context) {
                                final myInvestsList = investStore.myInvestsList;
                                return InvestCarousel(
                                  height: 108,
                                  children: [
                                    for (final instrument in myInvestsList) ...[
                                      SymbolInfo(
                                        percent: investStore.getPercentSymbol(instrument.symbol ?? ''),
                                        instrument: instrument,
                                        showProfit: true,
                                        profit: getGroupedProfit(instrument.symbol ?? ''),
                                        price: investStore.getPriceBySymbol(instrument.symbol ?? ''),
                                        onTap: () {
                                          final positions = investPositionsStore.activeList
                                              .where((element) => element.symbol == instrument.symbol)
                                              .toList();

                                          if (positions.length > 1) {
                                            sRouter.push(
                                              InstrumentPageRouter(instrument: instrument),
                                            );
                                          } else {
                                            sRouter.push(
                                              ActiveInvestManageRouter(
                                                instrument: instrument,
                                                position: positions.first,
                                              ),
                                            );
                                          }
                                        },
                                        candles: investChartStore.getAssetCandles(instrument.symbol ?? ''),
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      SPaddingH24(
                        child: NewInvestHeader(
                          showRollover: false,
                          showModify: false,
                          showIcon: true,
                          showFull: false,
                          title: intl.invest_favorites,
                          onButtonTap: () {
                            showInvestFavoritesBottomSheet(context);
                          },
                        ),
                      ),
                      const SpaceH4(),
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Observer(
                          builder: (BuildContext context) {
                            return InvestCarousel(
                              children: [
                                for (final element in investStore.favouritesList)
                                  SymbolInfo(
                                    percent: investStore.getPercentSymbol(element.symbol ?? ''),
                                    instrument: element,
                                    showProfit: false,
                                    price: investStore.getPriceBySymbol(element.symbol ?? ''),
                                    onTap: () {
                                      if (getGroupedLength(element.symbol ?? '') > 0) {
                                        sRouter.push(
                                          InstrumentPageRouter(instrument: element),
                                        );
                                      } else {
                                        sRouter.push(
                                          NewInvestPageRouter(instrument: element),
                                        );
                                      }
                                    },
                                    candles: investChartStore.getAssetCandles(element.symbol ?? ''),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (investStore.gainersList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        SPaddingH24(
                          child: NewInvestHeader(
                            showRollover: false,
                            showModify: false,
                            showIcon: false,
                            showFull: false,
                            title: intl.invest_top_gainers,
                          ),
                        ),
                        const SpaceH4(),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Observer(
                            builder: (BuildContext context) {
                              return InvestCarousel(
                                children: [
                                  for (final element in investStore.gainersList)
                                    SymbolInfo(
                                      percent: investStore.getPercentSymbol(element.symbol ?? ''),
                                      instrument: element,
                                      showProfit: false,
                                      price: investStore.getPriceBySymbol(element.symbol ?? ''),
                                      onTap: () {
                                        if (getGroupedLength(element.symbol ?? '') > 0) {
                                          sRouter.push(
                                            InstrumentPageRouter(instrument: element),
                                          );
                                        } else {
                                          sRouter.push(
                                            NewInvestPageRouter(instrument: element),
                                          );
                                        }
                                      },
                                      candles: investChartStore.getAssetCandles(element.symbol ?? ''),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (investStore.losersList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        SPaddingH24(
                          child: NewInvestHeader(
                            showRollover: false,
                            showModify: false,
                            showIcon: false,
                            showFull: false,
                            title: intl.invest_top_loosers,
                          ),
                        ),
                        const SpaceH4(),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Observer(
                            builder: (BuildContext context) {
                              return InvestCarousel(
                                children: [
                                  for (final element in investStore.losersList)
                                    SymbolInfo(
                                      percent: investStore.getPercentSymbol(element.symbol ?? ''),
                                      instrument: element,
                                      showProfit: false,
                                      price: investStore.getPriceBySymbol(element.symbol ?? ''),
                                      onTap: () {
                                        if (getGroupedLength(element.symbol ?? '') > 0) {
                                          sRouter.push(
                                            InstrumentPageRouter(instrument: element),
                                          );
                                        } else {
                                          sRouter.push(
                                            NewInvestPageRouter(instrument: element),
                                          );
                                        }
                                      },
                                      candles: investChartStore.getAssetCandles(element.symbol ?? ''),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Column(
                    children: [
                      SPaddingH24(
                        child: NewInvestHeader(
                          showRollover: false,
                          showModify: false,
                          showIcon: false,
                          showFull: false,
                          showViewAll: true,
                          title: intl.invest_market_watch,
                          onButtonTap: () {
                            investStore.setActiveSection('all');
                            showInvestMarketWatchBottomSheet(context);
                          },
                        ),
                      ),
                      const SpaceH12(),
                      Builder(
                        builder: (context) {
                          final sections = investStore.sections.where((section) => section.id != 'all').toList();
                          return GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisExtent: 127,
                            ),
                            itemCount: sections.length,
                            itemBuilder: (context, i) {
                              return SectorsBlock(
                                title: sections[i].name ?? '',
                                description: '${investStore.instrumentsList.where(
                                      (element) => element.sectors?.contains(sections[i].id) ?? false,
                                    ).toList().length} ${intl.invest_tokens}',
                                onTap: () {
                                  investStore.setActiveSection(sections[i].id ?? '');
                                  showInvestMarketWatchBottomSheet(context);
                                },
                                inageUrl: sections[i].smallIconUrl ?? '',
                              );
                            },
                          );
                        },
                      ),
                      const SpaceH24(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
