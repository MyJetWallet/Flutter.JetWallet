import 'package:cached_network_image/cached_network_image.dart';
import 'package:charts/simple_chart.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/invest/stores/chart/invest_chart_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/dashboard/new_invest_header.dart';
import 'package:jetwallet/features/invest/ui/dashboard/symbol_info_line.dart';
import 'package:jetwallet/features/invest/ui/invests/secondary_switch.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_input.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../../core/router/app_router.dart';

void showInvestMarketWatchBottomSheet(BuildContext context) {
  final investStore = getIt.get<InvestDashboardStore>();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    sShowBasicModalBottomSheet(
      context: context,
      scrollable: true,
      expanded: true,
      pinned: Observer(
        builder: (BuildContext context) {
          return SPaddingH24(
            child: Column(
              children: [
                NewInvestHeader(
                  title: intl.invest_market_watch,
                  showRollover: false,
                  showModify: false,
                  showIcon: false,
                  showFull: false,
                  onButtonTap: () {},
                ),
                const SpaceH4(),
                SecondarySwitch(
                  onChangeTab: investStore.setActiveSectionByIndex,
                  fromRight: false,
                  activeTab: investStore.sections.indexWhere(
                    (element) => element.id == investStore.activeSection,
                  ),
                  tabs: [
                    ...investStore.sections.map((section) => section.name!),
                  ],
                ),
                const SpaceH4(),
              ],
            ),
          );
        },
      ),
      horizontalPinnedPadding: 0,
      removePinnedPadding: true,
      horizontalPadding: 0,
      children: [const InstrumentsList()],
    );
  });
}

class InstrumentsList extends StatelessObserverWidget {
  const InstrumentsList();

  @override
  Widget build(BuildContext context) {
    final investStore = getIt.get<InvestDashboardStore>();
    final investChartStore = getIt.get<InvestChartStore>();
    final investPositionsStore = getIt.get<InvestPositionsStore>();
    final colors = sKit.colors;

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

    Decimal getGroupedAmount(String symbol) {
      final groupedPositions = investPositionsStore.activeList
          .where(
            (element) => element.symbol == symbol,
          )
          .toList();
      var amount = Decimal.zero;
      for (var i = 0; i < groupedPositions.length; i++) {
        amount += groupedPositions[i].amount ?? Decimal.zero;
      }

      return amount;
    }

    return Observer(
      builder: (BuildContext context) {
        final section = investStore.sectionById;

        return Column(
          children: [
            CachedNetworkImage(
              imageUrl: section.bigIconUrl ?? '',
              width: MediaQuery.of(context).size.width,
              placeholder: (context, url) {
                return const SizedBox(height: 104.8);
              },
              errorWidget: (context, url, error) {
                return const Offstage();
              },
              fit: BoxFit.fitWidth,
              fadeInDuration: Duration.zero,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 8,
              ),
              child: GestureDetector(
                onTap: investStore.setShortDescription,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          section.name ?? '',
                          style: STStyles.header2Invest.copyWith(
                            color: colors.black,
                          ),
                        ),
                        const SpaceW8(),
                        Column(
                          children: [
                            Text(
                              '${investStore.instrumentsList.where(
                                    (element) =>
                                        element.sectors?.contains(
                                          investStore.activeSection,
                                        ) ??
                                        false,
                                  ).toList().length} ${intl.invest_tokens}',
                              style: STStyles.body3InvestM.copyWith(
                                color: colors.grey1,
                              ),
                            ),
                            const SpaceH3(),
                          ],
                        ),
                      ],
                    ),
                    const SpaceH8(),
                    Text(
                      section.description ?? '',
                      style: STStyles.body2InvestM.copyWith(
                        color: colors.grey1,
                      ),
                      maxLines: investStore.isShortDescription ? 2 : 10,
                    ),
                    const SpaceH8(),
                    Center(
                      child: SafeGesture(
                        onTap: investStore.setShortDescription,
                        child: investStore.isShortDescription
                            ? Assets.svg.invest.investArrow.simpleSvg(
                                width: 14,
                                height: 14,
                              )
                            : RotatedBox(
                                quarterTurns: 2,
                                child: Assets.svg.invest.investArrow.simpleSvg(
                                  width: 14,
                                  height: 14,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SPaddingH24(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InvestInput(
                          onChanged: investStore.onSearchInput,
                          icon: Row(
                            children: [
                              Assets.svg.invest.investSearch.simpleSvg(
                                width: 12,
                                height: 12,
                              ),
                              const SpaceW10(),
                            ],
                          ),
                          controller: investStore.searchController,
                        ),
                      ),
                      const SpaceW10(),
                      SafeGesture(
                        onTap: investStore.setInstrumentSort,
                        child: investStore.instrumentSort == 0
                            ? Assets.svg.invest.sortNotSet.simpleSvg(
                                width: 20,
                                height: 20,
                                color: colors.black,
                              )
                            : investStore.instrumentSort == 1
                                ? Assets.svg.invest.sortUp.simpleSvg(
                                    width: 20,
                                    height: 20,
                                  )
                                : Assets.svg.invest.sortDown.simpleSvg(
                                    width: 20,
                                    height: 20,
                                  ),
                      ),
                    ],
                  ),
                  const SpaceH4(),
                  for (final instrument in investStore.instrumentsSortedList) ...[
                    FutureBuilder<List<CandleModel>>(
                      future: investChartStore.getAssetCandles(instrument.symbol ?? ''),
                      builder: (context, snapshot) {
                        return SymbolInfoLine(
                          percent: investStore.getPercentSymbol(instrument.symbol ?? ''),
                          instrument: instrument,
                          withActiveInvest: getGroupedLength(instrument.symbol!) > 0,
                          amount: getGroupedAmount(instrument.symbol!),
                          profit: getGroupedProfit(instrument.symbol!),
                          price: investStore.getPriceBySymbol(instrument.symbol ?? ''),
                          candles: snapshot.data ?? [],
                          onTap: () {
                            if (investStore.myInvestsList.contains(instrument) ||
                                investStore.myInvestPendingList.contains(instrument)) {
                              sRouter.push(
                                InstrumentPageRouter(instrument: instrument),
                              );
                            } else {
                              sRouter.push(
                                NewInvestPageRouter(instrument: instrument),
                              );
                            }
                          },
                        );
                      },
                    ),
                    const SDivider(),
                  ],
                  const SpaceH34(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
