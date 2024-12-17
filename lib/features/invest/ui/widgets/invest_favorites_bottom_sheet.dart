import 'package:charts/simple_chart.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/invest/stores/chart/invest_chart_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/dashboard/invest_header.dart';
import 'package:jetwallet/features/invest/ui/dashboard/new_invest_header.dart';
import 'package:jetwallet/features/invest/ui/dashboard/symbol_info_line.dart';
import 'package:jetwallet/features/invest/ui/invests/above_list_line.dart';
import 'package:jetwallet/features/invest/ui/invests/secondary_switch.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_input.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/helpers/currency_from.dart';

void showInvestFavoritesBottomSheet(BuildContext context) {
  final investStore = getIt.get<InvestDashboardStore>();
  final currencies = sSignalRModules.currenciesList;
  final currency = currencyFrom(currencies, 'USDT');
  investStore.setFavoritesEdit(false);

  showBasicBottomSheet(
    context: context,
    expanded: true,
    button: Observer(
      builder: (BuildContext context) {
        return SPaddingH24(
          child: Column(
            children: [
              Observer(
                builder: (BuildContext context) {
                  return investStore.isFavoritesEditMode
                      ? InvestHeader(
                          currency: currency,
                          hideWallet: true,
                          withBackBlock: true,
                          withBigPadding: false,
                          onBackButton: investStore.setFavoritesEditMode,
                        )
                      : NewInvestHeader(
                          title: investStore.isFavoritesEditMode ? intl.invest_edit_favorites : intl.invest_favorites,
                          showRollover: false,
                          showModify: false,
                          showIcon: false,
                          showFull: false,
                          showTextButton: true,
                          textButtonName: investStore.isFavoritesEditMode ? intl.invest_reset_all : intl.invest_edit,
                          onButtonTap: investStore.isFavoritesEditMode
                              ? investStore.resetFavorites
                              : investStore.setFavoritesEditMode,
                        );
                },
              ),
            ],
          ),
        );
      },
    ),
    children: [const InstrumentsList()],
  );
}

class InstrumentsList extends StatelessObserverWidget {
  const InstrumentsList();

  @override
  Widget build(BuildContext context) {
    final investStore = getIt.get<InvestDashboardStore>();
    final investChartStore = getIt.get<InvestChartStore>();
    final investPositionsStore = getIt.get<InvestPositionsStore>();

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

    return SPaddingH24(
      child: Observer(
        builder: (BuildContext context) {
          return Column(
            children: [
              if (investStore.isFavoritesEditMode) ...[
                Observer(
                  builder: (BuildContext context) {
                    return NewInvestHeader(
                      title: investStore.isFavoritesEditMode ? intl.invest_edit_favorites : intl.invest_favorites,
                      showRollover: false,
                      showModify: false,
                      showIcon: false,
                      showFull: false,
                      showTextButton: true,
                      textButtonName: investStore.isFavoritesEditMode ? intl.invest_reset_all : intl.invest_edit,
                      onButtonTap: investStore.isFavoritesEditMode
                          ? investStore.resetFavorites
                          : investStore.setFavoritesEditMode,
                    );
                  },
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
                    SafeGesture(
                      onTap: investStore.setInstrumentSort,
                      child: investStore.instrumentSort == 0
                          ? Assets.svg.invest.sortNotSet.simpleSvg(
                              width: 14,
                              height: 14,
                            )
                          : investStore.instrumentSort == 1
                              ? Assets.svg.invest.sortUp.simpleSvg(
                                  width: 14,
                                  height: 14,
                                )
                              : Assets.svg.invest.sortDown.simpleSvg(
                                  width: 14,
                                  height: 14,
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
                        amount: getGroupedAmount(instrument.symbol!),
                        profit: getGroupedProfit(instrument.symbol!),
                        price: investStore.getPriceBySymbol(instrument.symbol ?? ''),
                        withFavorites: true,
                        isFavorite: investStore.favoritesSymbols.contains(instrument.name),
                        candles: snapshot.data ?? [],
                        onTapFavorites: () {
                          if (investStore.favoritesSymbols.contains(instrument.name)) {
                            investStore.removeFromFavorites(instrument.name!);
                          } else {
                            investStore.addToFavorites(instrument.name!);
                          }
                        },
                        onTap: () {
                          if (investStore.favoritesSymbols.contains(instrument.name)) {
                            investStore.removeFromFavorites(instrument.name!);
                          } else {
                            investStore.addToFavorites(instrument.name!);
                          }
                        },
                      );
                    },
                  ),
                  const SDivider(),
                ],
                const SpaceH34(),
              ] else ...[
                AboveListLine(
                  mainColumn: intl.invest_favorites_instrument,
                  secondaryColumn: '',
                  lastColumn: intl.invest_favorites_price,
                  onCheckboxTap: (value) {},
                  withSort: true,
                  onSortTap: investStore.setFavoritesSort,
                  sortState: investStore.favoritesSort,
                ),
                for (final instrument in investStore.favoritesSortedList) ...[
                  FutureBuilder<List<CandleModel>>(
                    future: investChartStore.getAssetCandles(instrument.symbol ?? ''),
                    builder: (context, snapshot) {
                      return SymbolInfoLine(
                        percent: investStore.getPercentSymbol(instrument.symbol ?? ''),
                        instrument: instrument,
                        amount: getGroupedAmount(instrument.symbol!),
                        profit: getGroupedProfit(instrument.symbol!),
                        price: investStore.getPriceBySymbol(instrument.symbol ?? ''),
                        candles: snapshot.data ?? [],
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
                      );
                    },
                  ),
                  const SDivider(),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}
