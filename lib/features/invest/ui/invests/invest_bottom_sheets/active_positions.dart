import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/invests/above_list_line.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../../utils/helpers/currency_from.dart';
import '../../../../actions/action_send/widgets/show_send_timer_alert_or.dart';
import '../../../../kyc/helper/kyc_alert_handler.dart';
import '../../../../kyc/kyc_service.dart';
import '../../../../kyc/models/kyc_operation_status_model.dart';
import '../../widgets/invest_empty_screen.dart';
import '../../widgets/invest_market_watch_bottom_sheet.dart';
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

    Decimal getGroupedProfitPercent (String symbol) {
      final groupedPositions = investPositionsStore.activeList.where(
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

    Decimal getGroupedLeverage (String symbol) {
      final groupedPositions = investPositionsStore.activeList.where(
        (element) => element.symbol == symbol,
      ).toList();
      var leverage = 0;
      for (var i = 0; i < groupedPositions.length; i++) {
        leverage += groupedPositions[i].multiplicator ?? 0;
      }

      return Decimal.fromJson('${(Decimal.fromInt(leverage) / Decimal.fromInt(groupedPositions.length)).toDouble()}');
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

    InvestPositionModel getPosition (String symbol) {
      final groupedPositions = investPositionsStore.activeList.where(
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
        return Column(
          children: [
            Observer(
              builder: (BuildContext context) {
                var amountSum = Decimal.zero;
                var profitSum = Decimal.zero;
                if (sSignalRModules.investPositionsData != null &&
                    sSignalRModules.investPositionsData!.positions.isNotEmpty) {
                  final activePositions = sSignalRModules.investPositionsData!
                      .positions.where(
                        (element) => element.status == PositionStatus.opened,
                  ).toList();
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
                  amount: instrument != null
                    ? getGroupedAmount(instrument!.symbol ?? '')
                    : amountSum,
                  balance:  instrument != null
                    ? getGroupedProfit(instrument!.symbol ?? '')
                    : profitSum,
                  percent: instrument != null
                    ? getGroupedProfitPercent(instrument!.symbol ?? '')
                    : Decimal.fromJson('${(Decimal.fromInt(100) * profitSum / amountSum).toDouble()}'),
                  onShare: () {},
                  currency: currency,
                  title: intl.invest_active_invest,
                );
              },
            ),
            if (
              !investPositionsStore.isActiveGrouped ||
              (investPositionsStore.isActiveGrouped &&
              investPositionsStore.instrumentsList.where(
                (element) => getGroupedLength(element.symbol ?? '') > 1,
              ).toList().isNotEmpty
            ))
              AboveListLine(
                mainColumn:  instrument != null
                  ? intl.invest_in_group
                  : intl.invest_group,
                secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                lastColumn: '${intl.invest_list_pl} (${currency.symbol})',
                withCheckbox: instrument == null,
                withSort: true,
                checked: investPositionsStore.isActiveGrouped,
                onCheckboxTap: investPositionsStore.setIsActiveGrouped,
                sortState: investPositionsStore.activeSortState,
                onSortTap: investPositionsStore.setActiveSort,
              ),
            Observer(
              builder: (BuildContext context) {
                if (investPositionsStore.activeList.isEmpty) {
                  return InvestEmptyScreen(
                    width: MediaQuery.of(context).size.width - 48,
                    height: MediaQuery.of(context).size.height - 284,
                    title: sSignalRModules.investWalletData?.balance == Decimal.zero
                      ? intl.invest_active_empty_deposit
                      : intl.invest_active_empty,
                    buttonName: sSignalRModules.investWalletData?.balance == Decimal.zero
                      ? intl.invest_deposit
                      : intl.invest_new_invest,
                    onButtonTap: () {
                      if (sSignalRModules.investWalletData?.balance == Decimal.zero) {
                        final actualAsset = currency;
                        final kycState = getIt.get<KycService>();
                        final kycAlertHandler = getIt.get<KycAlertHandler>();
                        if (kycState.tradeStatus == kycOperationStatus(KycStatus.allowed)) {
                          showSendTimerAlertOr(
                            context: context,
                            or: () => sRouter.push(
                              ConvertRouter(
                                fromCurrency: actualAsset,
                              ),
                            ),
                            from: [BlockingType.trade],
                          );
                        } else {
                          kycAlertHandler.handle(
                            status: kycState.tradeStatus,
                            isProgress: kycState.verificationInProgress,
                            currentNavigate: () => showSendTimerAlertOr(
                              context: context,
                              or: () => sRouter.push(
                                ConvertRouter(
                                  fromCurrency: actualAsset,
                                ),
                              ),
                              from: [BlockingType.trade],
                            ),
                            requiredDocuments: kycState.requiredDocuments,
                            requiredVerifications: kycState.requiredVerifications,
                          );
                        }
                      } else {
                        investStore.setActiveSection('all');
                        showInvestMarketWatchBottomSheet(context);
                      }
                    },
                  );
                }

                if (instrument != null) {
                  final positions = investPositionsStore.activeList
                      .where((element) => element.symbol == instrument!.symbol)
                      .toList();
                  positions.sort((a, b) {
                    if (investPositionsStore.activeSortState == 1) {
                      return investStore.getProfitByPosition(b)
                          .compareTo(investStore.getProfitByPosition(a));
                    } else if (investPositionsStore.activeSortState == 2) {
                      return investStore.getProfitByPosition(a)
                          .compareTo(investStore.getProfitByPosition(b));
                    }

                    return 0.compareTo(1);
                  });

                  return Column(
                    children: [
                      for (final position in positions) ...[
                        InvestLine(
                          currency: currencyFrom(currencies, getInstrumentBySymbol(position.symbol ?? '').name ?? ''),
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
                        if (position.id != positions.last.id)
                          const SDivider(),
                      ],
                    ],
                  );
                }
                if (investPositionsStore.isActiveGrouped) {
                  return Column(
                    children: [
                      for (final instrument in investPositionsStore.instrumentsList) ...[
                        if (getGroupedLength(instrument.symbol ?? '') > 1) ...[
                          InvestLine(
                            currency: currencyFrom(currencies, instrument.name ?? ''),
                            price: Decimal.zero,
                            operationType: Direction.undefined,
                            isPending: false,
                            amount: getGroupedAmount(instrument.symbol ?? ''),
                            leverage: getGroupedLeverage(instrument.symbol ?? ''),
                            isGroup: true,
                            historyCount: getGroupedLength(instrument.symbol ?? ''),
                            profit: getGroupedProfit(instrument.symbol ?? ''),
                            profitPercent: getGroupedProfitPercent(instrument.symbol ?? ''),
                            accuracy: instrument.priceAccuracy ?? 2,
                            onTap: () {
                              sRouter.push(
                                InstrumentPageRouter(instrument: instrument),
                              );
                            },
                          ),
                          if (instrument.symbol != investPositionsStore.instrumentsList.where(
                            (element) => getGroupedLength(element.symbol ?? '') > 1,
                          ).toList().last.symbol)
                            const SDivider(),
                        ],
                      ],
                      const SpaceH10(),
                      if (
                        investPositionsStore.instrumentsList.where(
                          (element) => getGroupedLength(element.symbol ?? '') == 1,
                        ).toList().isNotEmpty
                      )
                        AboveListLine(
                          mainColumn: intl.invest_single,
                          secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                          lastColumn: '${intl.invest_list_pl} (${currency.symbol})',
                          withSort: true,
                          checked: investPositionsStore.isActiveGrouped,
                          onCheckboxTap: investPositionsStore.setIsActiveGrouped,
                          sortState: investPositionsStore.activeSortState,
                          onSortTap: investPositionsStore.setActiveSort,
                        ),
                      for (final instrument in investPositionsStore.instrumentsList) ...[
                        if (getGroupedLength(instrument.symbol ?? '') == 1) ...[
                          InvestLine(
                            currency: currencyFrom(currencies, instrument.name ?? ''),
                            price: Decimal.zero,
                            operationType: getPosition(instrument.symbol ?? '').direction ?? Direction.undefined,
                            isPending: false,
                            amount: getPosition(instrument.symbol ?? '').amount ?? Decimal.zero,
                            leverage: getGroupedLeverage(instrument.symbol ?? ''),
                            isGroup: false,
                            historyCount: 1,
                            profit: getGroupedProfit(instrument.symbol ?? ''),
                            profitPercent: getGroupedProfitPercent(instrument.symbol ?? ''),
                            accuracy: instrument.priceAccuracy ?? 2,
                            onTap: () {
                              sRouter.push(
                                ActiveInvestManageRouter(
                                  instrument: instrument,
                                  position: getPosition(instrument.symbol ?? ''),
                                ),
                              );
                            },
                          ),
                          if (instrument.symbol != investPositionsStore.instrumentsList.where(
                                (element) => getGroupedLength(element.symbol ?? '') == 1,
                          ).toList().last.symbol)
                            const SDivider(),
                        ],
                      ],
                    ],
                  );
                }
                final positions = investPositionsStore.activeList;
                positions.sort((a, b) {
                  if (investPositionsStore.activeSortState == 1) {
                    return investStore.getProfitByPosition(b)
                        .compareTo(investStore.getProfitByPosition(a));
                  } else if (investPositionsStore.activeSortState == 2) {
                    return investStore.getProfitByPosition(a)
                        .compareTo(investStore.getProfitByPosition(b));
                  }

                  return 0.compareTo(1);
                });

                return Column(
                  children: [
                    for (final position in positions) ...[
                      InvestLine(
                        currency: currencyFrom(currencies, getInstrumentBySymbol(position.symbol ?? '').name ?? ''),
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
}
