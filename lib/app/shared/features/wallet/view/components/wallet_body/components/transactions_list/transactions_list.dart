import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
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
    this.assetId,
    required this.scrollController,
    required this.errorBoxPaddingMultiplier,
  }) : super(key: key);

  final ScrollController scrollController;
  final double errorBoxPaddingMultiplier;
  final String? assetId;

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
            widget.assetId,
          ),
        );

        if (transactionHistory.union == const OperationHistoryUnion.loaded() &&
            !transactionHistory.nothingToLoad) {
          final transactionHistoryN = context.read(
            operationHistoryNotipod(
              widget.assetId,
            ).notifier,
          );

          transactionHistoryN.operationHistory(widget.assetId);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final initTransactionHistory = useProvider(
      operationHistoryInitFpod(
        widget.assetId,
      ),
    );
    final transactionHistoryN = useProvider(
      operationHistoryNotipod(
        widget.assetId,
      ).notifier,
    );
    final transactionHistory = useProvider(
      operationHistoryNotipod(
        widget.assetId,
      ),
    );
    final screenHeight = MediaQuery.of(context).size.height;

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
              if (transactionHistory.operationHistoryItems.isEmpty) {
                return const LoadingSliverList();
              } else {
                return SliverGroupedListView<OperationHistoryItem, String>(
                  elements: transactionHistory.operationHistoryItems,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(
                      text: date,
                    );
                  },
                  groupComparator: (date1, date2) => 0,
                  itemBuilder: (context, transaction) {
                    final index = transactionHistory.operationHistoryItems
                        .indexOf(transaction);
                    final currentDate = formatDate(transaction.timeStamp);
                    var nextDate = '';
                    if (index !=
                        (transactionHistory.operationHistoryItems.length - 1)) {
                      nextDate = formatDate(
                        transactionHistory
                            .operationHistoryItems[index + 1].timeStamp,
                      );
                    }
                    final removeDividerForLastInGroup = currentDate != nextDate;

                    if (transactionHistory.operationHistoryItems
                            .indexOf(transaction) ==
                        transactionHistory.operationHistoryItems.length - 1) {
                      return Column(
                        children: [
                          SPaddingH24(
                            child: TransactionListItem(
                              transactionListItem: transaction,
                              removeDivider: removeDividerForLastInGroup,
                            ),
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
                      return SPaddingH24(
                        child: TransactionListItem(
                          transactionListItem: transaction,
                          removeDivider: removeDividerForLastInGroup,
                        ),
                      );
                    }
                  },
                );
              }
            },
            loaded: () {
              return SliverGroupedListView<OperationHistoryItem, String>(
                elements: transactionHistory.operationHistoryItems,
                groupBy: (transaction) {
                  return formatDate(transaction.timeStamp);
                },
                groupSeparatorBuilder: (String date) {
                  return TransactionMonthSeparator(
                    text: date,
                  );
                },
                groupComparator: (date1, date2) => 0,
                itemBuilder: (context, transaction) {
                  final index = transactionHistory.operationHistoryItems
                      .indexOf(transaction);
                  final currentDate = formatDate(transaction.timeStamp);
                  var nextDate = '';
                  if (index !=
                      (transactionHistory.operationHistoryItems.length - 1)) {
                    nextDate = formatDate(
                      transactionHistory
                          .operationHistoryItems[index + 1].timeStamp,
                    );
                  }
                  final removeDividerForLastInGroup = currentDate != nextDate;

                  if (transactionHistory.operationHistoryItems
                          .indexOf(transaction) ==
                      transactionHistory.operationHistoryItems.length - 1) {
                    return SPaddingH24(
                      child: TransactionListItem(
                        transactionListItem: transaction,
                        removeDivider: removeDividerForLastInGroup,
                      ),
                    );
                  } else {
                    return SPaddingH24(
                      child: TransactionListItem(
                        transactionListItem: transaction,
                        removeDivider: removeDividerForLastInGroup,
                      ),
                    );
                  }
                },
              );
            },
            error: () {
              if (transactionHistory.operationHistoryItems.isEmpty) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        width: double.infinity,
                        height: 137,
                        margin: EdgeInsets.only(
                          top: screenHeight -
                              (screenHeight * widget.errorBoxPaddingMultiplier),
                          left: 24,
                          right: 24,
                          bottom: 24,
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
                                          'Something went wrong when '
                                          'loading your data',
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
                              name: 'Retry',
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
                  elements: transactionHistory.operationHistoryItems,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(
                      text: date,
                    );
                  },
                  groupComparator: (date1, date2) => 0,
                  itemBuilder: (context, transaction) {
                    final index = transactionHistory.operationHistoryItems
                        .indexOf(transaction);
                    final currentDate = formatDate(transaction.timeStamp);
                    var nextDate = '';
                    if (index !=
                        (transactionHistory.operationHistoryItems.length - 1)) {
                      nextDate = formatDate(
                        transactionHistory
                            .operationHistoryItems[index + 1].timeStamp,
                      );
                    }
                    final removeDividerForLastInGroup = currentDate != nextDate;

                    if (transactionHistory.operationHistoryItems
                            .indexOf(transaction) ==
                        transactionHistory.operationHistoryItems.length - 1) {
                      return Column(
                        children: [
                          SPaddingH24(
                            child: TransactionListItem(
                              transactionListItem: transaction,
                              removeDivider: removeDividerForLastInGroup,
                            ),
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
                                              'Something went wrong '
                                              'when '
                                              'loading your data',
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
                                  name: 'Retry',
                                  onTap: () {
                                    transactionHistoryN.operationHistory(
                                      widget.assetId,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SPaddingH24(
                        child: TransactionListItem(
                          transactionListItem: transaction,
                          removeDivider: removeDividerForLastInGroup,
                        ),
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
                  margin: EdgeInsets.only(
                    top: screenHeight -
                        (screenHeight * widget.errorBoxPaddingMultiplier),
                    left: 24,
                    right: 24,
                    bottom: 24,
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
                                    'Something went wrong when '
                                    'loading your data',
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
                        name: 'Retry',
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

  bool _addBottomPadding(OperationHistoryState transactionHistory) {
    return (transactionHistory.union != const OperationHistoryUnion.error()) &&
        !transactionHistory.nothingToLoad;
  }
}
