import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../helper/format_date.dart';
import '../../../../../notifier/operation_history_notipod.dart';
import '../../../../../notifier/operation_history_state.dart';
import '../../../../../notifier/operation_history_union.dart';
import '../../../../../provider/operation_history_fpod.dart';
import '../loading_sliver_list.dart';
import '../transaction_month_separator.dart';
import '../transactions_list_item/transaction_list_item.dart';

// TODO: Refactor this widget
class TransactionsList extends StatefulHookWidget {
  const TransactionsList({
    Key? key,
    this.isRecurring = false,
    this.symbol,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;
  final String? symbol;
  final bool isRecurring;

  @override
  State<StatefulWidget> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent ==
          widget.scrollController.offset) {
        final transactionHistory = context.read(
          operationHistoryNotipod(
            widget.symbol,
          ),
        );

        if (transactionHistory.union == const OperationHistoryUnion.loaded() &&
            !transactionHistory.nothingToLoad) {
          final transactionHistoryN = context.read(
            operationHistoryNotipod(
              widget.symbol,
            ).notifier,
          );

          transactionHistoryN.operationHistory(widget.symbol);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final initTransactionHistory = useProvider(
      operationHistoryInitFpod(
        widget.symbol,
      ),
    );
    final transactionHistoryN = useProvider(
      operationHistoryNotipod(
        widget.symbol,
      ).notifier,
    );
    final transactionHistory = useProvider(
      operationHistoryNotipod(
        widget.symbol,
      ),
    );
    final screenHeight = MediaQuery.of(context).size.height;
    final listToShow = widget.isRecurring
        ? transactionHistory.operationHistoryItems
            .where(
              (i) => i.operationType == OperationType.recurringBuy,
            )
            .toList()
        : transactionHistory.operationHistoryItems;

    return SliverPadding(
      padding: EdgeInsets.only(
        top: transactionHistory.union != const OperationHistoryUnion.error()
            ? 15
            : 0,
        bottom: _addBottomPadding(transactionHistory) ? 72 : 0,
      ),
      sliver: initTransactionHistory.when(
        data: (_) {
          return transactionHistory.union.when(
            loading: () {
              if (listToShow.isEmpty) {
                return const LoadingSliverList();
              } else {
                return SliverGroupedListView<OperationHistoryItem, String>(
                  elements: listToShow,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  sort: false,
                  groupSeparatorBuilder: (String date) {
                    return _displayMonthSeparator(date, listToShow);
                  },
                  itemBuilder: (context, transaction) {
                    final index = listToShow.indexOf(transaction);
                    final currentDate = formatDate(transaction.timeStamp);
                    var nextDate = '';
                    if (index != (listToShow.length - 1)) {
                      nextDate = formatDate(
                        listToShow[index + 1].timeStamp,
                      );
                    }
                    final removeDividerForLastInGroup = currentDate != nextDate;

                    if (listToShow.indexOf(transaction) ==
                        listToShow.length - 1) {
                      return Column(
                        children: [
                          TransactionListItem(
                            transactionListItem: transaction,
                            removeDivider: removeDividerForLastInGroup,
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
                      );
                    } else {
                      return TransactionListItem(
                        transactionListItem: transaction,
                        removeDivider: removeDividerForLastInGroup,
                      );
                    }
                  },
                );
              }
            },
            loaded: () {
              if (listToShow.isEmpty) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: screenHeight - screenHeight * 0.369,
                    child: Column(
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
                    ),
                  ),
                );
              } else {
                return SliverGroupedListView<OperationHistoryItem, String>(
                  elements: listToShow,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  sort: false,
                  groupSeparatorBuilder: (String date) {
                    return _displayMonthSeparator(date, listToShow);
                  },
                  itemBuilder: (context, transaction) {
                    final index = listToShow.indexOf(transaction);
                    final currentDate = formatDate(transaction.timeStamp);
                    var nextDate = '';
                    if (index != (listToShow.length - 1)) {
                      nextDate = formatDate(
                        listToShow[index + 1].timeStamp,
                      );
                    }
                    final removeDividerForLastInGroup = currentDate != nextDate;

                    return TransactionListItem(
                      transactionListItem: transaction,
                      removeDivider: removeDividerForLastInGroup,
                    );
                  },
                );
              }
            },
            error: () {
              if (listToShow.isEmpty) {
                return SliverList(
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
                                transactionHistoryN.initOperationHistory();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SliverGroupedListView<OperationHistoryItem, String>(
                  elements: listToShow,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  groupSeparatorBuilder: (String date) {
                    return _displayMonthSeparator(date, listToShow);
                  },
                  groupComparator: (date1, date2) => 0,
                  itemBuilder: (context, transaction) {
                    final index = listToShow.indexOf(transaction);
                    final currentDate = formatDate(transaction.timeStamp);
                    var nextDate = '';
                    if (index != (listToShow.length - 1)) {
                      nextDate = formatDate(
                        listToShow[index + 1].timeStamp,
                      );
                    }
                    final removeDividerForLastInGroup = currentDate != nextDate;

                    if (listToShow.indexOf(transaction) ==
                        listToShow.length - 1) {
                      return Column(
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
                                    transactionHistoryN.operationHistory(
                                      widget.symbol,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return TransactionListItem(
                        transactionListItem: transaction,
                        removeDivider: removeDividerForLastInGroup,
                      );
                    }
                  },
                );
              }
            },
          );
        },
        loading: () => const LoadingSliverList(),
        error: (_, __) {
          return SliverList(
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
                          transactionHistoryN.initOperationHistory();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _displayMonthSeparator(String date, List<OperationHistoryItem> list) {
    final currentMonthInt = DateTime.now().month;
    final month = DateFormat('MMM').format(DateTime(0, currentMonthInt));

    final displaySeparator = _findTransactionInCurrentMonth(
      list,
      currentMonthInt,
    );

    if (date == month) {
      return const SizedBox();
    }

    if (date != month && !displaySeparator) {
      return const SizedBox();
    }

    return TransactionMonthSeparator(
      text: date,
    );
  }

  bool _findTransactionInCurrentMonth(
    List<OperationHistoryItem> list,
    int currentMonthInt,
  ) {
    for (final element in list) {
      final elementDate =
          DateTime.parse('${element.timeStamp}Z').toLocal().month;

      if (elementDate == currentMonthInt) {
        return true;
      }
    }

    return false;
  }

  bool _addBottomPadding(OperationHistoryState transactionHistory) {
    return (transactionHistory.union != const OperationHistoryUnion.error()) &&
        !transactionHistory.nothingToLoad;
  }
}
