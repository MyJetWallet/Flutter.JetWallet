import 'dart:async';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/transaction_list_item.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../../../../../utils/constants.dart';
import '../../../../../helper/format_date.dart';
import '../../../../../helper/nft_types.dart';
import '../transaction_month_separator.dart';
import '../transactions_list_item/transaction_list_loading_item.dart';

class TransactionsMainList extends StatefulWidget {
  const TransactionsMainList({
    super.key,
    this.isRecurring = false,
    this.zeroPadding = false,
    this.symbol,
    this.filter = TransactionType.none,
    this.jwOperationId,
    this.pendingOnly = false,
  });

  final String? symbol;
  final TransactionType filter;
  final bool isRecurring;
  final bool zeroPadding;
  final String? jwOperationId;
  final bool pendingOnly;

  @override
  State<TransactionsMainList> createState() => _TransactionsMainListState();
}

class _TransactionsMainListState extends State<TransactionsMainList> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Provider<OperationHistory>(
      create: (context) => OperationHistory(
        widget.symbol,
        widget.filter,
        widget.isRecurring,
        widget.jwOperationId,
        widget.pendingOnly,
        null,
      )..initOperationHistory(),
      //dispose: (context, value) => value.stopTimer(),
      builder: (context, child) => _TransactionsListBody(
        symbol: widget.symbol,
        isRecurring: widget.isRecurring,
        zeroPadding: widget.zeroPadding,
        filter: widget.filter,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _TransactionsListBody extends StatefulObserverWidget {
  const _TransactionsListBody({
    this.isRecurring = false,
    this.zeroPadding = false,
    this.filter = TransactionType.none,
    this.symbol,
  });

  final String? symbol;
  final bool isRecurring;
  final bool zeroPadding;
  final TransactionType filter;

  @override
  State<StatefulWidget> createState() => _TransactionsListBodyState();
}

class _TransactionsListBodyState extends State<_TransactionsListBody> {
  @override
  void initState() {
    OperationHistory.of(context).scrollController.addListener(() {
      final nextPageTrigger = 0.8 * OperationHistory.of(context).scrollController.position.maxScrollExtent;

      if (OperationHistory.of(context).scrollController.position.pixels > nextPageTrigger) {
        if (OperationHistory.of(context).union == const OperationHistoryUnion.loaded() &&
            !OperationHistory.of(context).nothingToLoad) {
          OperationHistory.of(context).operationHistory(widget.symbol);
        }
      }
    });

    Timer(
      const Duration(
        milliseconds: 1000,
      ),
      () {
        if (!OperationHistory.of(context).nothingToLoad && OperationHistory.of(context).listToShow.length < 20) {
          OperationHistory.of(context).operationHistory(widget.symbol);
        }
      },
    );
    super.initState();
  }

  static const double _indicatorSize = 75;
  bool _scrollingHasAlreadyOccurred = false;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = OperationHistory.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: store.union != const OperationHistoryUnion.error() ? 15 : 0,
        bottom: widget.zeroPadding
            ? 0
            : _addBottomPadding()
                ? 25
                : 0,
      ),
      child: store.listToShow.isEmpty
          ? store.union is Error
              ? transactionError()
              : store.union is Loading
                  ? transactionSkeleton()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          emptyHistoryAsset,
                          width: 80,
                        ),
                        const SpaceH24(),
                        Text(
                          intl.transactionsList_noTransactionsYet,
                          style: sTextH5Style,
                        ),
                        const SpaceH8(),
                        Text(
                          intl.historyRecurringBuy_text1,
                          style: sBodyText1Style.copyWith(
                            color: colors.grey1,
                          ),
                        ),
                        const SpaceH120(),
                      ],
                    )
          : CustomRefreshIndicator(
              offsetToArmed: _indicatorSize,
              onRefresh: () => store.refreshHistory(),
              builder: (
                BuildContext context,
                Widget child,
                IndicatorController controller,
              ) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget? _) {
                        return SizedBox(
                          height: controller.value * _indicatorSize,
                          child: Container(
                            width: 24.0,
                            decoration: BoxDecoration(
                              color: colors.grey5,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const RiveAnimation.asset(
                              loadingAnimationAsset,
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      builder: (context, _) {
                        return Transform.translate(
                          offset: Offset(0.0, controller.value * _indicatorSize),
                          child: child,
                        );
                      },
                      animation: controller,
                    ),
                  ],
                );
              },
              child: NotificationListener<ScrollStartNotification>(
                onNotification: (scrollNotification) {
                  if (!_scrollingHasAlreadyOccurred) {
                    _scrollingHasAlreadyOccurred = true;
                    sAnalytics.swipeHistoryListOnGlobalTransactionHistoryScreen(
                      globalHistoryTab:
                          OperationHistory.of(context).pendingOnly ? GlobalHistoryTab.pending : GlobalHistoryTab.all,
                    );
                  }

                  return false;
                },
                child: GroupedListView<OperationHistoryItem, String>(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: OperationHistory.of(context).scrollController,
                  elements: store.listToShow,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  sort: false,
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(text: date);
                  },
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, transaction) {
                    return Column(
                      children: [
                        TransactionListItem(
                          transactionListItem: transaction,
                          onItemTapLisener: (_) {
                            sAnalytics.tapOnTheButtonAnyHistoryTrxOnGlobalTransactionHistoryScreen(
                              globalHistoryTab: OperationHistory.of(context).pendingOnly
                                  ? GlobalHistoryTab.pending
                                  : GlobalHistoryTab.all,
                            );
                          },
                        ),
                        if (store.isLoading &&
                            store.listToShow.indexOf(transaction) == store.listToShow.length - 1) ...[
                          const SpaceH16(),
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
                          const SpaceH24(),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
      /*child: store.union.when(
        loaded: () {
          return store.listToShow.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      intl.transactionsList_noTransactionsYet,
                      style: sTextH3Style,
                    ),
                    Text(
                      intl.historyRecurringBuy_text1,
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                  ],
                )
              : GroupedListView<OperationHistoryItem, String>(
                  //elements: OperationHistory.of(context).listToShow,
                  elements: store.listToShow,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  sort: false,
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(text: date);
                  },
                  padding: EdgeInsets.zero,
                  controller: OperationHistory.of(context).scrollController,
                  //physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, transaction) {
                    final index = store.listToShow.indexOf(transaction);
                    final currentDate = formatDate(transaction.timeStamp);
                    var nextDate = '';
                    if (index != (store.listToShow.length - 1)) {
                      nextDate =
                          formatDate(store.listToShow[index + 1].timeStamp);
                    }
                    final removeDividerForLastInGroup = currentDate != nextDate;

                    return TransactionListItem(
                      transactionListItem: transaction,
                      removeDivider: removeDividerForLastInGroup,
                    );
                  },
                );
        },
        error: () {
          return store.listToShow.isEmpty
              ? Column(
                  children: [
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
                              OperationHistory.of(context)
                                  .initOperationHistory();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : GroupedListView<OperationHistoryItem, String>(
                  elements: store.listToShow,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(text: date);
                  },
                  groupComparator: (date1, date2) => 0,
                  itemBuilder: (context, transaction) {
                    final index = store.listToShow.indexOf(transaction);
                    final currentDate = formatDate(transaction.timeStamp);
                    var nextDate = '';
                    if (index != (store.listToShow.length - 1)) {
                      nextDate =
                          formatDate(store.listToShow[index + 1].timeStamp);
                    }
                    final removeDividerForLastInGroup = currentDate != nextDate;

                    return store.listToShow.indexOf(transaction) ==
                            store.listToShow.length - 1
                        ? Column(
                            children: [
                              TransactionListItem(
                                transactionListItem: transaction,
                                removeDivider: removeDividerForLastInGroup,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                baselineType:
                                                    TextBaseline.alphabetic,
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
                                        OperationHistory.of(context)
                                            .operationHistory(
                                          widget.symbol,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : TransactionListItem(
                            transactionListItem: transaction,
                            removeDivider: removeDividerForLastInGroup,
                          );
                  },
                );
        },
        loading: () {
          return store.listToShow.isEmpty
              ? transactionSkeleton()
              : GroupedListView<OperationHistoryItem, String>(
                  elements: store.listToShow,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  sort: false,
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(text: date);
                  },
                  itemBuilder: (context, transaction) {
                    final index = store.listToShow.indexOf(transaction);
                    final currentDate = formatDate(transaction.timeStamp);
                    var nextDate = '';
                    if (index != (store.listToShow.length - 1)) {
                      nextDate =
                          formatDate(store.listToShow[index + 1].timeStamp);
                    }
                    final removeDividerForLastInGroup = currentDate != nextDate;

                    return store.listToShow.indexOf(transaction) ==
                            store.listToShow.length - 1
                        ? Column(
                            children: [
                              TransactionListItem(
                                transactionListItem: transaction,
                                removeDivider: removeDividerForLastInGroup,
                              ),
                              const SpaceH16(),
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
                              const SpaceH24(),
                            ],
                          )
                        : TransactionListItem(
                            transactionListItem: transaction,
                            removeDivider: removeDividerForLastInGroup,
                          );
                  },
                );
        },
      ),
      */
    );
  }

  bool _addBottomPadding() {
    return (OperationHistory.of(context).union != const OperationHistoryUnion.error()) &&
        !OperationHistory.of(context).nothingToLoad;
  }

  Widget transactionSkeleton() {
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
  }

  Widget transactionError() {
    final colors = sKit.colors;

    return Column(
      children: [
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
                  OperationHistory.of(context).initOperationHistory();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
