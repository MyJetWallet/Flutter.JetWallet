import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';
import '../../../../core/di/di.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/helpers/currency_from.dart';
import '../../../actions/action_send/widgets/show_send_timer_alert_or.dart';
import '../../../kyc/helper/kyc_alert_handler.dart';
import '../../../kyc/kyc_service.dart';
import '../../../kyc/models/kyc_operation_status_model.dart';
import '../../../wallet/helper/format_date.dart';
import '../../../wallet/ui/widgets/wallet_body/widgets/loading_sliver_list.dart';
import '../../../wallet/ui/widgets/wallet_body/widgets/transaction_month_separator.dart';
import '../../stores/dashboard/invest_dashboard_store.dart';
import '../../stores/history/invest_history_store.dart';
import '../invests/invest_line.dart';
import 'invest_empty_screen.dart';
import 'invest_market_watch_bottom_sheet.dart';

class InvestHistoryList extends StatelessWidget {
  const InvestHistoryList({
    super.key,
    required this.scrollController,
    this.onItemTapLisener,
  });

  final ScrollController scrollController;
  final void Function(InvestPositionModel position)? onItemTapLisener;

  @override
  Widget build(BuildContext context) {
    return Provider<InvestHistory>(
      create: (context) => InvestHistory()..initInvestHistory(),
      builder: (context, child) => _TransactionsListBody(
        scrollController: scrollController,
        onItemTapLisener: onItemTapLisener,
      ),
      //dispose: (context, value) => value.stopTimer(),
    );
  }
}

class _TransactionsListBody extends StatefulObserverWidget {
  const _TransactionsListBody({
    required this.scrollController,
    this.onItemTapLisener,
  });

  final ScrollController scrollController;
  final void Function(InvestPositionModel position)? onItemTapLisener;

  @override
  State<StatefulWidget> createState() => _TransactionsListBodyState();
}

class _TransactionsListBodyState extends State<_TransactionsListBody> {
  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent <= widget.scrollController.offset) {
        if (InvestHistory.of(context).union == const OperationHistoryUnion.loaded() &&
            !InvestHistory.of(context).nothingToLoad) {
          InvestHistory.of(context).investHistory();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final listToShow = InvestHistory.of(context).investHistoryItems;
    final currencies = sSignalRModules.currenciesList;
    final currency = currencyFrom(currencies, 'USDT');
    final investStore = getIt.get<InvestDashboardStore>();

    InvestInstrumentModel? getInstrumentBySymbol (String symbol) {
      final instrument = investStore.instrumentsList.where(
            (element) => element.symbol == symbol,
      ).toList();

      if (instrument.isNotEmpty) {
        return instrument[0];
      }

      return null;
    }

    return SliverPadding(
      key: UniqueKey(),
      padding: EdgeInsets.only(
        top: InvestHistory.of(context).union != const OperationHistoryUnion.error() ? 15 : 0,
        bottom: _addBottomPadding() ? 72 : 0,
      ),
      sliver: InvestHistory.of(context).union.when(
        loaded: () {
          return listToShow.isEmpty
              ? SliverToBoxAdapter(
                  child: SizedBox(
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
                          investStore.setActiveSection('S0');
                          showInvestMarketWatchBottomSheet(context);
                        }
                      },
                    ),
                  ),
                )
              : SliverGroupedListView<InvestPositionModel, String>(
                  elements: listToShow,
                  groupBy: (position) {
                    return formatDate('${position.creationTimestamp}');
                  },
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(text: date);
                  },
                  sort: false,
                  itemBuilder: (context, position) {
                    return InvestLine(
                        currency: currencyFrom(currencies, getInstrumentBySymbol(position.symbol ?? '')?.name ?? ''),
                        price: position.profitLoss ?? Decimal.zero,
                        operationType: position.direction ?? Direction.undefined,
                        isPending: true,
                        amount: position.amount ?? Decimal.zero,
                        leverage: position.multiplicator ?? 0,
                        isGroup: false,
                        historyCount: 1,
                        profit: investStore.getProfitByPosition(position),
                        profitPercent: investStore.getYieldByPosition(position),
                        accuracy: getInstrumentBySymbol(position.symbol ?? '')?.priceAccuracy ?? 2,
                        onTap: () {},
                      );
                  },
                );
        },
        error: () {
          return listToShow.isEmpty
              ? SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
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
                                InvestHistory.of(context).initInvestHistory();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : SliverGroupedListView<InvestPositionModel, String>(
                  elements: listToShow,
                  groupBy: (position) {
                    return formatDate('${position.creationTimestamp}');
                  },
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(text: date);
                  },
                  groupComparator: (date1, date2) => 0,
                  itemBuilder: (context, position) {
                    return listToShow.indexOf(position) == listToShow.length - 1
                        ? Column(
                            children: [
                              InvestLine(
                                currency: currencyFrom(currencies, getInstrumentBySymbol(position.symbol ?? '')?.name ?? ''),
                                price: position.profitLoss ?? Decimal.zero,
                                operationType: position.direction ?? Direction.undefined,
                                isPending: true,
                                amount: position.amount ?? Decimal.zero,
                                leverage: position.multiplicator ?? 0,
                                isGroup: false,
                                historyCount: 1,
                                profit: investStore.getProfitByPosition(position),
                                profitPercent: investStore.getYieldByPosition(position),
                                accuracy: getInstrumentBySymbol(position.symbol ?? '')?.priceAccuracy ?? 2,
                                onTap: () {},
                              ),
                              Container(
                                width: double.infinity,
                                height: 137,
                                margin: const EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                  bottom: 24,
                                  top: 10,
                                ),
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
                                        InvestHistory.of(context).investHistory();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : InvestLine(
                          currency: currencyFrom(currencies, getInstrumentBySymbol(position.symbol ?? '')?.name ?? ''),
                          price: position.profitLoss ?? Decimal.zero,
                          operationType: position.direction ?? Direction.undefined,
                          isPending: true,
                          amount: position.amount ?? Decimal.zero,
                          leverage: position.multiplicator ?? 0,
                          isGroup: false,
                          historyCount: 1,
                          profit: investStore.getProfitByPosition(position),
                          profitPercent: investStore.getYieldByPosition(position),
                          accuracy: getInstrumentBySymbol(position.symbol ?? '')?.priceAccuracy ?? 2,
                          onTap: () {},
                        );
                  },
                );
        },
        loading: () {
          return listToShow.isEmpty
              ? const LoadingSliverList()
              : SliverGroupedListView<InvestPositionModel, String>(
                  elements: listToShow,
                  groupBy: (position) {
                    return formatDate('${position.creationTimestamp}');
                  },
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(text: date);
                  },
                  sort: false,
                  itemBuilder: (context, position) {
                    return listToShow.indexOf(position) == listToShow.length - 1
                        ? Column(
                            children: [
                              InvestLine(
                                currency: currencyFrom(currencies, getInstrumentBySymbol(position.symbol ?? '')?.name ?? ''),
                                price: position.profitLoss ?? Decimal.zero,
                                operationType: position.direction ?? Direction.undefined,
                                isPending: true,
                                amount: position.amount ?? Decimal.zero,
                                leverage: position.multiplicator ?? 0,
                                isGroup: false,
                                historyCount: 1,
                                profit: investStore.getProfitByPosition(position),
                                profitPercent: investStore.getYieldByPosition(position),
                                accuracy: getInstrumentBySymbol(position.symbol ?? '')?.priceAccuracy ?? 2,
                                onTap: () {},
                              ),
                              const SpaceH24(),
                              Container(
                                width: 24.0,
                                height: 24.0,
                                decoration: BoxDecoration(
                                  color: colors.grey5,
                                  shape: BoxShape.circle,
                                ),
                                child: const RiveAnimation.asset(
                                  loadingAnimationAsset,
                                ),
                              ),
                            ],
                          )
                        : InvestLine(
                          currency: currencyFrom(currencies, getInstrumentBySymbol(position.symbol ?? '')?.name ?? ''),
                          price: position.profitLoss ?? Decimal.zero,
                          operationType: position.direction ?? Direction.undefined,
                          isPending: true,
                          amount: position.amount ?? Decimal.zero,
                          leverage: position.multiplicator ?? 0,
                          isGroup: false,
                          historyCount: 1,
                          profit: investStore.getProfitByPosition(position),
                          profitPercent: investStore.getYieldByPosition(position),
                          accuracy: getInstrumentBySymbol(position.symbol ?? '')?.priceAccuracy ?? 2,
                          onTap: () {},
                        );
                      },
                    );
        },
      ),
    );
  }

  bool _addBottomPadding() {
    return (InvestHistory.of(context).union != const OperationHistoryUnion.error()) &&
        !InvestHistory.of(context).nothingToLoad;
  }
}
