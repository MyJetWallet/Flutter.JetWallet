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
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/helpers/currency_from.dart';

void showInvestMarketWatchBottomSheet(BuildContext context) {
  final investStore = getIt.get<InvestDashboardStore>();

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
                  ...investStore.sections.map((section) => section.name!).toList(),
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
    children: [InstrumentsList()],
  );
}

class InstrumentsList extends StatelessObserverWidget {
  InstrumentsList();

  @override
  Widget build(BuildContext context) {
    final investStore = getIt.get<InvestDashboardStore>();
    final investChartStore = getIt.get<InvestChartStore>();
    final investPositionsStore = getIt.get<InvestPositionsStore>();
    final currencies = sSignalRModules.currenciesList;
    final colors = sKit.colors;

    int getGroupedLength (String symbol) {
      final groupedPositions = investPositionsStore.activeList.where(
            (element) => element.symbol == symbol,
      );

      return groupedPositions.length;
    }

    Decimal getGroupedProfit (String symbol) {
      final groupedPositions = investPositionsStore.activeList.where(
            (element) => element.symbol == symbol,
      ).toList();
      var profit = Decimal.zero;
      for (var i = 0; i < groupedPositions.length; i++) {
        profit += investStore.getProfitByPosition(groupedPositions[i]);
      }

      return profit;
    }

    Decimal getGroupedAmount (String symbol) {
      final groupedPositions = investPositionsStore.activeList.where(
            (element) => element.symbol == symbol,
      ).toList();
      var amount = Decimal.zero;
      for (var i = 0; i < groupedPositions.length; i++) {
        amount += groupedPositions[i].amount ?? Decimal.zero;
      }

      return amount;
    }

    return Observer(
      builder: (BuildContext context) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 8,
              ),
              decoration: BoxDecoration(
                color: colors.grey5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        investStore.sectionById.name ?? '',
                        style: STStyles.header2Invest.copyWith(
                          color: colors.black,
                        ),
                      ),
                      const SpaceW8(),
                      Column(
                        children: [
                          Text(
                            '${investStore
                                .instrumentsList
                                .where(
                                  (element) => element
                                  .sectors?.contains(investStore.activeSection)
                                  ?? false,
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
                    investStore.sectionById.description ?? '',
                    style: STStyles.body2InvestM.copyWith(
                      color: colors.grey1,
                    ),
                    maxLines: investStore.isShortDescription ? 2 : 10,
                  ),
                  const SpaceH8(),
                  Center(
                    child: SIconButton(
                      onTap: investStore.setShortDescription,
                      defaultIcon: investStore.isShortDescription
                          ? Assets.svg.invest.investArrow.simpleSvg(width: 14, height: 14,)
                          : RotatedBox(
                        quarterTurns: 2,
                        child: Assets.svg.invest.investArrow.simpleSvg(width: 14, height: 14,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SPaddingH24(
              child: Column(
                children: [
                  const SpaceH16(),
                  Row(
                    children: [
                      Expanded(
                        child: InvestInput(
                          onChanged: investStore.onSearchInput,
                          icon: Row(
                            children: [
                              Assets.svg.invest.investSearch.simpleSvg(
                                width: 16,
                                height: 16,
                              ),
                              const SpaceW10(),
                            ],
                          ),
                          controller: investStore.searchController,
                        ),
                      ),
                      const SpaceW10(),
                      SIconButton(
                        onTap: investStore.setInstrumentSort,
                        defaultIcon: investStore.instrumentSort == 0
                            ? Assets.svg.invest.sortNotSet.simpleSvg(width: 14, height: 14,)
                            : investStore.instrumentSort == 1
                            ? Assets.svg.invest.sortUp.simpleSvg(width: 14, height: 14,)
                            : Assets.svg.invest.sortDown.simpleSvg(width: 14, height: 14,),
                        pressedIcon: investStore.instrumentSort == 0
                            ? Assets.svg.invest.sortNotSet.simpleSvg(width: 14, height: 14,)
                            : investStore.instrumentSort == 1
                            ? Assets.svg.invest.sortUp.simpleSvg(width: 14, height: 14,)
                            : Assets.svg.invest.sortDown.simpleSvg(width: 14, height: 14,),
                      ),
                    ],
                  ),
                  const SpaceH4(),
                  for (final instrument in investStore.instrumentsSortedList) ...[
                    SymbolInfoLine(
                      percent: investStore.getPercentSymbol(instrument.symbol ?? ''),
                      instrument: instrument,
                      withActiveInvest: getGroupedLength(instrument.symbol!) > 0,
                      amount: getGroupedAmount(instrument.symbol!),
                      profit: getGroupedProfit(instrument.symbol!),
                      price: investStore.getPriceBySymbol(instrument.symbol ?? ''),
                      candles: investChartStore.getAssetCandles(instrument.symbol ?? ''),
                      onTap: () {
                        if (getGroupedLength(instrument.symbol!) > 0) {
                          sRouter.push(
                            InstrumentPageRouter(instrument: instrument),
                          );
                        } else {
                          sRouter.push(
                            NewInvestPageRouter(instrument: instrument),
                          );
                        }
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
