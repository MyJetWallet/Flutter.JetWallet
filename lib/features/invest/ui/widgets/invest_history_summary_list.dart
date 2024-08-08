import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';
import '../../../../core/di/di.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/helpers/currency_from.dart';
import '../../../actions/action_send/widgets/show_send_timer_alert_or.dart';
import '../../../kyc/helper/kyc_alert_handler.dart';
import '../../../kyc/kyc_service.dart';
import '../../../kyc/models/kyc_operation_status_model.dart';
import '../../../transaction_history/widgets/transaction_list_loading_item.dart';
import '../../helpers/invest_period_info.dart';
import '../../stores/dashboard/invest_dashboard_store.dart';
import '../../stores/dashboard/invest_positions_store.dart';
import '../../stores/history/invest_history_store.dart';
import '../invests/above_list_line.dart';
import '../invests/invest_line.dart';
import '../invests/main_invest_block.dart';
import '../invests/secondary_switch.dart';
import 'invest_empty_screen.dart';
import 'invest_market_watch_bottom_sheet.dart';
import 'invest_period_bottom_sheet.dart';

class InvestHistorySummaryList extends StatelessWidget {
  const InvestHistorySummaryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Provider<InvestHistory>(
      create: (context) => InvestHistory()..initInvestHistorySummary(),
      builder: (context, child) => const _TransactionsListBody(),
      //dispose: (context, value) => value.stopTimer(),
    );
  }
}

class _TransactionsListBody extends StatefulObserverWidget {
  const _TransactionsListBody();

  @override
  State<StatefulWidget> createState() => _TransactionsListBodyState();
}

class _TransactionsListBodyState extends State<_TransactionsListBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final listToShow = InvestHistory.of(context).investHistorySummaryItems;
    final currencies = sSignalRModules.currenciesList;
    final currency = currencyFrom(currencies, 'USDT');
    final investStore = getIt.get<InvestDashboardStore>();
    final investPositionsStore = getIt.get<InvestPositionsStore>();

    InvestInstrumentModel? getInstrumentBySymbol(String symbol) {
      final instrument = investStore.instrumentsList
          .where(
            (element) => element.symbol == symbol,
          )
          .toList();

      if (instrument.isNotEmpty) {
        return instrument[0];
      }

      return null;
    }

    Widget topOfPage() {
      return Column(
        children: [
          Row(
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  showInvestPeriodBottomSheet(
                    context,
                    (InvestHistoryPeriod value) {
                      investStore.updatePeriod(value);
                      InvestHistory.of(context).initInvestHistorySummary();
                    },
                    investStore.period,
                  );
                },
                child: Row(
                  children: [
                    Assets.svg.invest.investCalendar.simpleSvg(
                      width: 16,
                      height: 16,
                      color: colors.black,
                    ),
                    const SpaceW4(),
                    Text(
                      '${getDaysByPeriod(investStore.period)} ${intl.invest_period_days}',
                      style: STStyles.body1InvestSM,
                    ),
                    const SpaceW4(),
                    Assets.svg.invest.investArrow.simpleSvg(
                      width: 14,
                      height: 14,
                      color: colors.black,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (investPositionsStore.pendingList.isNotEmpty)
                Observer(
                  builder: (BuildContext context) {
                    return SecondarySwitch(
                      onChangeTab: investPositionsStore.setHistoryTab,
                      activeTab: investPositionsStore.historyTab,
                      fullWidth: false,
                      tabs: [
                        intl.invest_history_tab_invest,
                        intl.invest_history_tab_pending,
                      ],
                    );
                  },
                ),
            ],
          ),
          MainInvestBlock(
            pending: Decimal.zero,
            amount: investPositionsStore.totalAmount,
            balance: investPositionsStore.totalProfit,
            percent: investPositionsStore.totalProfitPercent,
            onShare: () {},
            currency: currency,
            title: intl.invest_history_invest,
          ),
          const SpaceH4(),
          if (investPositionsStore.historyTab == 0)
            AboveListLine(
              mainColumn: intl.invest_group,
              secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
              lastColumn: '${intl.invest_list_pl} (${currency.symbol})',
              withCheckbox: true,
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
        ],
      );
    }

    return Column(
      children: [
        topOfPage(),
        InvestHistory.of(context).unionSummary.when(
          loaded: () {
            return listToShow.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height - 284,
                    child: InvestEmptyScreen(
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
                    ),
                  )
                : Column(
                    children: [
                      for (final instrument in listToShow) ...[
                        if (instrument.qty! > Decimal.one) ...[
                          InvestLine(
                            currency: currencyFrom(
                              currencies,
                              getInstrumentBySymbol(instrument.symbol!)?.name ?? '',
                            ),
                            price: Decimal.zero,
                            operationType: Direction.undefined,
                            isPending: false,
                            amount: instrument.amount ?? Decimal.zero,
                            leverage: instrument.averageMultiplicator ?? Decimal.zero,
                            isGroup: true,
                            historyCount: instrument.qty!.toDouble().toInt(),
                            profit: instrument.amountPl!,
                            profitPercent: instrument.percentPl!,
                            accuracy: getInstrumentBySymbol(instrument.symbol!)?.priceAccuracy ?? 2,
                            onTap: () {
                              sRouter.push(
                                InvestHistoryPageRouter(
                                  instrument: getInstrumentBySymbol(
                                    instrument.symbol!,
                                  )!,
                                ),
                              );
                            },
                          ),
                          if (instrument.symbol !=
                              listToShow
                                  .where(
                                    (element) => element.qty! > Decimal.one,
                                  )
                                  .toList()
                                  .last
                                  .symbol)
                            const SDivider(),
                        ],
                      ],
                      const SpaceH10(),
                      if (listToShow
                          .where(
                            (element) => element.qty! > Decimal.one,
                          )
                          .toList()
                          .isNotEmpty)
                        AboveListLine(
                          mainColumn: intl.invest_single,
                          secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                          lastColumn: '${intl.invest_list_pl} (${currency.symbol})',
                          withSort: true,
                          checked: true,
                          onCheckboxTap: (value) {},
                        ),
                      for (final instrument in listToShow) ...[
                        if (instrument.qty == Decimal.one) ...[
                          InvestLine(
                            currency: currencyFrom(
                              currencies,
                              getInstrumentBySymbol(instrument.symbol!)?.name ?? '',
                            ),
                            price: Decimal.zero,
                            operationType: Direction.undefined,
                            isPending: false,
                            amount: instrument.amount ?? Decimal.zero,
                            leverage: instrument.averageMultiplicator ?? Decimal.zero,
                            isGroup: false,
                            historyCount: 1,
                            profit: instrument.amountPl ?? Decimal.zero,
                            profitPercent: instrument.percentPl ?? Decimal.zero,
                            accuracy: getInstrumentBySymbol(instrument.symbol!)?.priceAccuracy ?? 2,
                            onTap: () {
                              sRouter.push(
                                InvestHistoryPageRouter(
                                  instrument: getInstrumentBySymbol(
                                    instrument.symbol!,
                                  )!,
                                ),
                              );
                            },
                          ),
                          if (instrument.symbol !=
                              listToShow
                                  .where(
                                    (element) => element.qty! == Decimal.one,
                                  )
                                  .toList()
                                  .last
                                  .symbol)
                            const SDivider(),
                        ],
                      ],
                    ],
                  );
          },
          error: () {
            return Container(
              width: double.infinity,
              height: 137,
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 2,
                  color: colors.grey4,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 22,
                          top: 22,
                          right: 12,
                        ),
                        child: SErrorIcon(
                          color: colors.red,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 20,
                          ),
                          child: SizedBox(
                            height: 77,
                            child: Baseline(
                              baseline: 38,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                intl.newsList_wentWrongText,
                                style: sBodyText1Style,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  STextButton1(
                    active: true,
                    name: intl.transactionsList_retry,
                    onTap: () {
                      InvestHistory.of(context).initInvestHistorySummary();
                    },
                  ),
                ],
              ),
            );
          },
          loading: () {
            return const Column(
              children: [
                TransactionListLoadingItem(
                  opacity: 1,
                ),
                TransactionListLoadingItem(
                  opacity: 0.8,
                ),
                TransactionListLoadingItem(
                  opacity: 0.6,
                ),
                TransactionListLoadingItem(
                  opacity: 0.4,
                ),
                TransactionListLoadingItem(
                  opacity: 0.2,
                  removeDivider: true,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
