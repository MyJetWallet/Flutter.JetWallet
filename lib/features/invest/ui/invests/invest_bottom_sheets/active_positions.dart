import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/invests/above_list_line.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../../utils/helpers/currency_from.dart';
import '../invest_line.dart';
import '../main_invest_block.dart';

class ActiveInvestList extends StatelessObserverWidget {
  const ActiveInvestList({
    this.instrument,
  });

  final InvestInstrumentModel? instrument;

  @override
  Widget build(BuildContext context) {
    final investPositionsStore = getIt.get<InvestPositionsStore>();
    final investStore = getIt.get<InvestDashboardStore>();
    final currencies = sSignalRModules.currenciesList;
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

    Decimal getGroupedProfitPercent(String symbol) {
      final groupedPositions = investPositionsStore.activeList
          .where(
            (element) => element.symbol == symbol,
          )
          .toList();
      var profit = Decimal.zero;
      var amount = Decimal.zero;
      for (var i = 0; i < groupedPositions.length; i++) {
        profit += investStore.getProfitByPosition(groupedPositions[i]);
        amount += groupedPositions[i].amount ?? Decimal.zero;
      }

      return Decimal.fromJson(
        '${(Decimal.fromInt(100) * profit / amount).toDouble()}',
      );
    }

    Decimal getGroupedLeverage(String symbol) {
      final groupedPositions = investPositionsStore.activeList
          .where(
            (element) => element.symbol == symbol,
          )
          .toList();
      var leverage = 0;
      for (var i = 0; i < groupedPositions.length; i++) {
        leverage += groupedPositions[i].multiplicator ?? 0;
      }

      return Decimal.fromJson(
        '${(Decimal.fromInt(leverage) / Decimal.fromInt(groupedPositions.length)).toDouble()}',
      );
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

    InvestInstrumentModel getInstrumentBySymbol(String symbol) {
      final instrument = investPositionsStore.instrumentsList
          .where(
            (element) => element.symbol == symbol,
          )
          .toList();

      return instrument[0];
    }

    return Observer(
      builder: (BuildContext context) {
        return Column(
          children: [
            Observer(
              builder: (BuildContext context) {
                var amountSum = Decimal.zero;
                var profitSum = Decimal.zero;
                if (sSignalRModules.investPositionsData != null &&
                    sSignalRModules.investPositionsData!.positions.isNotEmpty) {
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

                if (amountSum == Decimal.zero) {
                  return MainInvestBlock(
                    pending: Decimal.zero,
                    amount: Decimal.zero,
                    balance: Decimal.zero,
                    percent: Decimal.zero,
                    onShare: () {},
                    currency: currency,
                    title: intl.invest_active_invest,
                  );
                }

                return MainInvestBlock(
                  pending: Decimal.zero,
                  amount: instrument != null ? getGroupedAmount(instrument?.symbol ?? '') : amountSum,
                  balance: instrument != null ? getGroupedProfit(instrument?.symbol ?? '') : profitSum,
                  percent: instrument != null
                      ? getGroupedProfitPercent(instrument?.symbol ?? '')
                      : Decimal.fromJson(
                          '${(Decimal.fromInt(100) * profitSum / amountSum).toDouble()}',
                        ),
                  onShare: () {},
                  currency: currency,
                  title: intl.invest_active_invest,
                );
              },
            ),
            if (!investPositionsStore.isActiveGrouped ||
                (investPositionsStore.isActiveGrouped &&
                    investPositionsStore.instrumentsList
                        .where(
                          (element) => getGroupedLength(element.symbol ?? '') > 1,
                        )
                        .toList()
                        .isNotEmpty))
              AboveListLine(
                mainColumn: instrument != null ? intl.invest_in_group : intl.invest_group,
                secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                lastColumn: '${intl.invest_list_pl} (${currency.symbol})',
                withCheckbox: instrument == null,
                checked: investPositionsStore.isActiveGrouped,
                onCheckboxTap: investPositionsStore.setIsActiveGrouped,
                withSort: !investPositionsStore.isActiveGrouped,
                sortState: investPositionsStore.activeSortState,
                onSortTap: investPositionsStore.setActiveSort,
              ),
            Observer(
              builder: (BuildContext context) {
                if (instrument != null) {
                  final positions =
                      investPositionsStore.activeList.where((element) => element.symbol == instrument!.symbol).toList();

                  positions.sort((a, b) {
                    if (a.creationTimestamp == null && b.creationTimestamp == null) {
                      return 0;
                    } else if (a.creationTimestamp == null) {
                      return 1;
                    } else if (b.creationTimestamp == null) {
                      return -1;
                    }

                    return b.creationTimestamp!.compareTo(a.creationTimestamp!);
                  });
                  return Column(
                    children: [
                      for (final position in positions) ...[
                        InvestLine(
                          currency: currencyFrom(
                            currencies,
                            getInstrumentBySymbol(position.symbol ?? '').name ?? '',
                          ),
                          price: investStore.getProfitByPosition(position),
                          operationType: position.direction ?? Direction.undefined,
                          isPending: false,
                          amount: position.amount ?? Decimal.zero,
                          leverage: Decimal.fromInt(position.multiplicator ?? 0),
                          isGroup: false,
                          historyCount: 1,
                          profit: investStore.getProfitByPosition(position),
                          profitPercent: investStore.getYieldByPosition(position),
                          accuracy: getInstrumentBySymbol(position.symbol ?? '').priceAccuracy ?? 2,
                          onTap: () {
                            sRouter.push(
                              ActiveInvestManageRouter(
                                instrument: getInstrumentBySymbol(
                                  position.symbol ?? '',
                                ),
                                position: position,
                              ),
                            );
                          },
                        ),
                        if (position.id != positions.last.id) const SDivider(),
                      ],
                    ],
                  );
                }
                if (investPositionsStore.isActiveGrouped) {
                  List<InvestPositionModel> positions;
                  if (instrument != null) {
                    positions = investPositionsStore.activeList
                        .where(
                          (element) => element.symbol == instrument!.symbol,
                        )
                        .toList();
                  } else {
                    positions = investPositionsStore.activeList.toList();
                  }
                  final groupedPositons = _getGroupedUniquePositionsSortedByProfit(
                    positions,
                    investPositionsStore,
                    investStore,
                  );
                  final uniquePositons = _filterOutRepeatedSymbols(positions);

                  final sortedUniquePositons = _sortPositons(
                    investPositionsStore,
                    investStore,
                    uniquePositons,
                  );

                  return Column(
                    children: [
                      for (final position in groupedPositons) ...[
                        InvestLine(
                          currency: currencyFrom(
                            currencies,
                            getInstrumentBySymbol(position.symbol ?? '').name ?? '',
                          ),
                          price: Decimal.zero,
                          operationType: Direction.undefined,
                          isPending: false,
                          amount: getGroupedAmount(position.symbol ?? ''),
                          leverage: getGroupedLeverage(position.symbol ?? ''),
                          isGroup: true,
                          historyCount: getGroupedLength(position.symbol ?? ''),
                          profit: getGroupedProfit(position.symbol ?? ''),
                          profitPercent: getGroupedProfitPercent(position.symbol ?? ''),
                          accuracy: getInstrumentBySymbol(position.symbol ?? '').priceAccuracy ?? 2,
                          onTap: () {
                            sRouter.push(
                              InstrumentPageRouter(
                                instrument: getInstrumentBySymbol(
                                  position.symbol ?? '',
                                ),
                              ),
                            );
                          },
                        ),
                        if (position != groupedPositons.last) const SDivider(),
                      ],
                      const SpaceH10(),
                      if (investPositionsStore.instrumentsList
                          .where(
                            (element) => getGroupedLength(element.symbol ?? '') == 1,
                          )
                          .toList()
                          .isNotEmpty)
                        AboveListLine(
                          mainColumn: intl.invest_single,
                          secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                          lastColumn: '${intl.invest_list_pl} (${currency.symbol})',
                          checked: investPositionsStore.isActiveGrouped,
                          onCheckboxTap: investPositionsStore.setIsActiveGrouped,
                          withSort: true,
                          sortState: investPositionsStore.activeSortState,
                          onSortTap: investPositionsStore.setActiveSort,
                        ),
                      for (final position in sortedUniquePositons) ...[
                        InvestLine(
                          currency: currencyFrom(
                            currencies,
                            getInstrumentBySymbol(position.symbol ?? '').name ?? '',
                          ),
                          price: investStore.getProfitByPosition(position),
                          operationType: position.direction ?? Direction.undefined,
                          isPending: false,
                          amount: position.amount ?? Decimal.zero,
                          leverage: Decimal.fromInt(position.multiplicator ?? 0),
                          isGroup: false,
                          historyCount: 1,
                          profit: investStore.getProfitByPosition(position),
                          profitPercent: investStore.getYieldByPosition(position),
                          accuracy: getInstrumentBySymbol(position.symbol ?? '').priceAccuracy ?? 2,
                          onTap: () {
                            sRouter.push(
                              ActiveInvestManageRouter(
                                instrument: getInstrumentBySymbol(
                                  position.symbol ?? '',
                                ),
                                position: position,
                              ),
                            );
                          },
                        ),
                        const SDivider(),
                      ],
                    ],
                  );
                }
                List<InvestPositionModel> positions;

                if (instrument != null) {
                  positions =
                      investPositionsStore.activeList.where((element) => element.symbol == instrument!.symbol).toList();
                } else {
                  positions = investPositionsStore.activeList.toList();
                }

                final sortedPositions = _sortPositons(
                  investPositionsStore,
                  investStore,
                  positions,
                );

                return Column(
                  children: [
                    for (final position in sortedPositions) ...[
                      InvestLine(
                        currency: currencyFrom(
                          currencies,
                          getInstrumentBySymbol(position.symbol ?? '').name ?? '',
                        ),
                        price: investStore.getProfitByPosition(position),
                        operationType: position.direction ?? Direction.undefined,
                        isPending: false,
                        amount: position.amount ?? Decimal.zero,
                        leverage: Decimal.fromInt(position.multiplicator ?? 0),
                        isGroup: false,
                        historyCount: 1,
                        profit: investStore.getProfitByPosition(position),
                        profitPercent: investStore.getYieldByPosition(position),
                        accuracy: getInstrumentBySymbol(position.symbol ?? '').priceAccuracy ?? 2,
                        onTap: () {
                          sRouter.push(
                            ActiveInvestManageRouter(
                              instrument: getInstrumentBySymbol(position.symbol ?? ''),
                              position: position,
                            ),
                          );
                        },
                      ),
                      const SDivider(),
                    ],
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  List<InvestPositionModel> _sortPositons(
    InvestPositionsStore investPositionsStore,
    InvestDashboardStore investStore,
    List<InvestPositionModel> positions,
  ) {
    if (investPositionsStore.activeSortState == 1) {
      positions.sort(
        (a, b) => investStore.getProfitByPosition(b).compareTo(investStore.getProfitByPosition(a)),
      );
    } else if (investPositionsStore.activeSortState == 2) {
      positions.sort(
        (a, b) => investStore.getProfitByPosition(a).compareTo(investStore.getProfitByPosition(b)),
      );
    } else {
      positions.sort((a, b) {
        if (a.creationTimestamp == null && b.creationTimestamp == null) {
          return 0;
        } else if (a.creationTimestamp == null) {
          return 1;
        } else if (b.creationTimestamp == null) {
          return -1;
        }
        return b.creationTimestamp!.compareTo(a.creationTimestamp!);
      });
    }
    return positions;
  }
}

List<InvestPositionModel> _filterOutRepeatedSymbols(
  List<InvestPositionModel> positions,
) {
  final symbolCounts = <String, int>{};

  for (final position in positions) {
    final symbol = position.symbol;

    if (symbol != null) {
      symbolCounts[symbol] = (symbolCounts[symbol] ?? 0) + 1;
    }
  }

  final filteredPositions = positions.where((position) {
    final symbol = position.symbol;
    return symbol != null && symbolCounts[symbol] == 1;
  }).toList();

  return filteredPositions;
}

/// Returns the grouped profit for the specified symbol
Decimal _getGroupedProfit(
  String symbol,
  InvestPositionsStore investPositionsStore,
  InvestDashboardStore investStore,
) {
  final groupedPositions = investPositionsStore.activeList.where((position) => position.symbol == symbol).toList();
  var profit = Decimal.zero;

  for (final position in groupedPositions) {
    profit += investStore.getProfitByPosition(position);
  }

  return profit;
}

List<InvestPositionModel> _getGroupedUniquePositionsSortedByProfit(
  List<InvestPositionModel> positions,
  InvestPositionsStore investPositionsStore,
  InvestDashboardStore investStore,
) {
  final symbolCounts = <String, int>{};
  final uniqueGroupedSymbols = <String>{};
  final groupedUniquePositions = <InvestPositionModel>[];

  for (final position in positions) {
    final symbol = position.symbol;

    if (symbol != null) {
      symbolCounts[symbol] = (symbolCounts[symbol] ?? 0) + 1;
    }
  }

  for (final position in positions) {
    final symbol = position.symbol;

    if (symbol != null && symbolCounts[symbol]! > 1 && !uniqueGroupedSymbols.contains(symbol)) {
      groupedUniquePositions.add(position);
      uniqueGroupedSymbols.add(symbol);
    }
  }

  groupedUniquePositions.sort((a, b) {
    final profitA = _getGroupedProfit(a.symbol ?? '', investPositionsStore, investStore);
    final profitB = _getGroupedProfit(b.symbol ?? '', investPositionsStore, investStore);

    return profitB.compareTo(profitA);
  });

  return groupedUniquePositions;
}
