import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/dashboard/invest_header.dart';
import 'package:jetwallet/features/invest/ui/dashboard/new_invest_header.dart';
import 'package:jetwallet/features/invest/ui/dashboard/symbol_info_line.dart';
import 'package:jetwallet/features/invest/ui/invests/above_list_line.dart';
import 'package:jetwallet/features/invest/ui/invests/secondary_switch.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_input.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/helpers/currency_from.dart';

void showInvestFavoritesBottomSheet(BuildContext context) {
  final investStore = getIt.get<InvestDashboardStore>();
  final currencies = sSignalRModules.currenciesList;
  final currency = currencyFrom(currencies, 'USDT');
  investStore.setFavoritesEdit(false);

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    expanded: true,
    pinned: Observer(
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
                      title: investStore.isFavoritesEditMode
                          ? intl.invest_edit_favorites
                          : intl.invest_favorites,
                      showRollover: false,
                      showModify: false,
                      showIcon: false,
                      showFull: false,
                      showTextButton: true,
                      textButtonName: investStore.isFavoritesEditMode
                          ? intl.invest_reset_all
                          : intl.invest_edit,
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
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [const InstrumentsList()],
  );
}

class InstrumentsList extends StatelessObserverWidget {
  const InstrumentsList();

  @override
  Widget build(BuildContext context) {
    final investStore = getIt.get<InvestDashboardStore>();
    final investPositionsStore = getIt.get<InvestPositionsStore>();
    final currencies = sSignalRModules.currenciesList;

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

    return SPaddingH24(
      child: Observer(
        builder: (BuildContext context) {
          return Column(
            children: [
              if (investStore.isFavoritesEditMode) ...[
                Observer(
                  builder: (BuildContext context) {
                    return NewInvestHeader(
                      title: investStore.isFavoritesEditMode
                          ? intl.invest_edit_favorites
                          : intl.invest_favorites,
                      showRollover: false,
                      showModify: false,
                      showIcon: false,
                      showFull: false,
                      showTextButton: true,
                      textButtonName: investStore.isFavoritesEditMode
                          ? intl.invest_reset_all
                          : intl.invest_edit,
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
                    ...investStore.sections.map((section) => section.name!).toList(),
                  ],
                ),
                const SpaceH4(),
                Row(
                  children: [
                    Expanded(
                      child: InvestInput(
                        onChanged: investStore.onSearchInput,
                        icon: const Row(
                          children: [
                            SISearchIcon(
                              width: 16,
                              height: 16,
                            ),
                            SpaceW10(),
                          ],
                        ),
                        controller: investStore.searchController,
                      ),
                    ),
                    const SpaceW10(),
                    SIconButton(
                      onTap: investStore.setInstrumentSort,
                      defaultIcon: investStore.instrumentSort == 0
                          ? const SISortNotSetIcon(width: 20, height: 20,)
                          : investStore.instrumentSort == 1
                          ? const SISortUpIcon(width: 20, height: 20,)
                          : const SISortDownIcon(width: 20, height: 20,),
                      pressedIcon: investStore.instrumentSort == 0
                          ? const SISortNotSetIcon(width: 20, height: 20,)
                          : investStore.instrumentSort == 1
                          ? const SISortUpIcon(width: 20, height: 20,)
                          : const SISortDownIcon(width: 20, height: 20,),
                    ),
                  ],
                ),
                const SpaceH4(),
                for (final instrument in investStore.instrumentsSortedList) ...[
                  SymbolInfoLine(
                    currency: currencyFrom(currencies, instrument.name!),
                    instrument: instrument,
                    amount: getGroupedAmount(instrument.symbol!),
                    profit: getGroupedProfit(instrument.symbol!),
                    price: investStore.getPriceBySymbol(instrument.symbol ?? ''),
                    withFavorites: true,
                    isFavorite: investStore.favoritesSymbols.contains(instrument.name),
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
                  SymbolInfoLine(
                    currency: currencyFrom(currencies, instrument.name!),
                    instrument: instrument,
                    amount: getGroupedAmount(instrument.symbol!),
                    profit: getGroupedProfit(instrument.symbol!),
                    price: investStore.getPriceBySymbol(instrument.symbol ?? ''),
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
              ],
            ],
          );
        },
      ),
    );
  }
}