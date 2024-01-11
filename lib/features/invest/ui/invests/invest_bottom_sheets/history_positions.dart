import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/invests/above_list_line.dart';
import 'package:jetwallet/features/invest/ui/invests/secondary_switch.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_history_list.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../../utils/helpers/currency_from.dart';
import '../invest_line.dart';
import '../main_invest_block.dart';

class HistoryInvestList extends StatelessObserverWidget {
  HistoryInvestList();

  @override
  Widget build(BuildContext context) {
    final investPositionsStore = getIt.get<InvestPositionsStore>();
    final investStore = getIt.get<InvestDashboardStore>();
    final currencies = sSignalRModules.currenciesList;
    final currency = currencyFrom(currencies, 'USDT');
    final ScrollController _scrollController = ScrollController();
    final ScrollController scrollController = ScrollController();

    int getGroupedLength (String symbol) {
      final groupedPositions = investPositionsStore.closedList.where(
        (element) => element.symbol == symbol,
      );

      return groupedPositions.length;
    }

    Decimal getGroupedProfit (String symbol) {
      final groupedPositions = investPositionsStore.closedList.where(
        (element) => element.symbol == symbol,
      ).toList();
      var profit = Decimal.zero;
      for (var i = 0; i < groupedPositions.length; i++) {
        profit += investStore.getProfitByPosition(groupedPositions[i]);
      }

      return profit;
    }

    Decimal getGroupedProfitPercent (String symbol) {
      final groupedPositions = investPositionsStore.closedList.where(
        (element) => element.symbol == symbol,
      ).toList();
      var profit = Decimal.zero;
      var amount = Decimal.zero;
      for (var i = 0; i < groupedPositions.length; i++) {
        profit += investStore.getProfitByPosition(groupedPositions[i]);
        amount += groupedPositions[i].amount ?? Decimal.zero;
      }

      return Decimal.fromJson('${(Decimal.fromInt(100) * profit / amount).toDouble()}');
    }

    int getGroupedLeverage (String symbol) {
      final groupedPositions = investPositionsStore.closedList.where(
        (element) => element.symbol == symbol,
      ).toList();
      var leverage = 0;
      for (var i = 0; i < groupedPositions.length; i++) {
        leverage += groupedPositions[i].multiplicator ?? 0;
      }

      return leverage ~/ groupedPositions.length;
    }

    Decimal getGroupedAmount (String symbol) {
      final groupedPositions = investPositionsStore.closedList.where(
        (element) => element.symbol == symbol,
      ).toList();
      var amount = Decimal.zero;
      for (var i = 0; i < groupedPositions.length; i++) {
        amount += groupedPositions[i].amount ?? Decimal.zero;
      }

      return amount;
    }

    InvestPositionModel getPosition (String symbol) {
      final groupedPositions = investPositionsStore.closedList.where(
        (element) => element.symbol == symbol,
      ).toList();

      return groupedPositions[0];
    }

    InvestInstrumentModel getInstrumentBySymbol (String symbol) {
      final instrument = investPositionsStore.instrumentsList.where(
        (element) => element.symbol == symbol,
      ).toList();

      return instrument[0];
    }

    return Observer(
      builder: (BuildContext context) {
        var amountSum = Decimal.zero;
        var profitSum = Decimal.zero;
        if (sSignalRModules.investPositionsData != null) {
          final activePositions = sSignalRModules.investPositionsData!
              .positions.where(
                (element) => element.status == PositionStatus.opened,
          ).toList();
          for (var i = 0; i < activePositions.length; i++) {
            amountSum += activePositions[i].amount!;
            profitSum += investStore.getProfitByPosition(activePositions[i]);
          }
        }

        return Column(
          children: [
            MainInvestBlock(
              pending: Decimal.zero,
              amount: amountSum,
              balance: profitSum,
              percent: Decimal.fromJson('${(Decimal.fromInt(100) * profitSum / amountSum).toDouble()}'),
              onShare: () {},
              currency: currency,
              title: intl.invest_history_invest,
            ),
            Observer(
              builder: (BuildContext context) {
                return SecondarySwitch(
                  onChangeTab: investPositionsStore.setHistoryTab,
                  activeTab: investPositionsStore.historyTab,
                  tabs: [
                    intl.invest_history_tab_invest,
                    intl.invest_history_tab_pending,
                  ],
                );
              },
            ),
            if (investPositionsStore.historyTab == 0)
              AboveListLine(
                mainColumn: intl.invest_group,
                secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                lastColumn: '${intl.invest_list_pl} (${currency.symbol})',
                withCheckbox: true,
                withSort: true,
                checked: investPositionsStore.isHistoryGrouped,
                onCheckboxTap: investPositionsStore.setIsHistoryGrouped,
                sortState: investPositionsStore.historySortState,
                onSortTap: investPositionsStore.setHistorySort,
              )
            else
              AboveListLine(
                mainColumn: intl.invest_list_instrument,
                secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                lastColumn: intl.invest_price,
                onCheckboxTap: investPositionsStore.setIsHistoryGrouped,
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 284,
              child: Observer(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    slivers: [
                      InvestHistoryList(scrollController: scrollController),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
