import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/market_details/helper/operation_history.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/transaction_list_item.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../helper/format_date.dart';
import '../loading_sliver_list.dart';
import '../transaction_month_separator.dart';

// TODO: Refactor this widget
class TransactionsList extends StatefulObserverWidget {
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
  late final OperationHistory transactionHistory;

  @override
  void initState() {
    transactionHistory = OperationHistory(widget.symbol);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent ==
          widget.scrollController.offset) {
        if (transactionHistory.union == const OperationHistoryUnion.loaded() &&
            !transactionHistory.nothingToLoad) {
          transactionHistory.operationHistory(widget.symbol);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final initTransactionHistory = operationHistoryInit(
      transactionHistory,
      widget.symbol,
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
      sliver: FutureBuilder<bool>(
        future: initTransactionHistory,
        builder: (context, snapshot) {
          print(snapshot.connectionState);

          return snapshot.hasData
              ? snapshot.hasError
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
                                    transactionHistory.initOperationHistory();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : transactionHistory.union.when(
                      loading: () {
                        return listToShow.isEmpty
                            ? const LoadingSliverList()
                            : SliverGroupedListView<OperationHistoryItem,
                                String>(
                                elements: listToShow,
                                groupBy: (transaction) {
                                  return formatDate(transaction.timeStamp);
                                },
                                sort: false,
                                groupSeparatorBuilder: (String date) {
                                  return TransactionMonthSeparator(text: date);
                                },
                                itemBuilder: (context, transaction) {
                                  final index = listToShow.indexOf(transaction);
                                  final currentDate =
                                      formatDate(transaction.timeStamp);
                                  var nextDate = '';
                                  if (index != (listToShow.length - 1)) {
                                    nextDate = formatDate(
                                      listToShow[index + 1].timeStamp,
                                    );
                                  }
                                  final removeDividerForLastInGroup =
                                      currentDate != nextDate;

                                  return listToShow.indexOf(transaction) ==
                                          listToShow.length - 1
                                      ? Column(
                                          children: [
                                            TransactionListItem(
                                              transactionListItem: transaction,
                                              removeDivider:
                                                  removeDividerForLastInGroup,
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
                                      : TransactionListItem(
                                          transactionListItem: transaction,
                                          removeDivider:
                                              removeDividerForLastInGroup,
                                        );
                                },
                              );
                      },
                      loaded: () {
                        return listToShow.isEmpty
                            ? SliverToBoxAdapter(
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
                              )
                            : SliverGroupedListView<OperationHistoryItem,
                                String>(
                                elements: listToShow,
                                groupBy: (transaction) {
                                  return formatDate(transaction.timeStamp);
                                },
                                sort: false,
                                groupSeparatorBuilder: (String date) {
                                  return TransactionMonthSeparator(text: date);
                                },
                                itemBuilder: (context, transaction) {
                                  final index = listToShow.indexOf(transaction);
                                  final currentDate =
                                      formatDate(transaction.timeStamp);
                                  var nextDate = '';
                                  if (index != (listToShow.length - 1)) {
                                    nextDate = formatDate(
                                      listToShow[index + 1].timeStamp,
                                    );
                                  }
                                  final removeDividerForLastInGroup =
                                      currentDate != nextDate;

                                  return TransactionListItem(
                                    transactionListItem: transaction,
                                    removeDivider: removeDividerForLastInGroup,
                                  );
                                },
                              );
                      },
                      error: () {
                        return listToShow.isEmpty
                            ? SliverList(
                                delegate: SliverChildListDelegate([
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
                                            transactionHistory
                                                .initOperationHistory();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              )
                            : SliverGroupedListView<OperationHistoryItem,
                                String>(
                                elements: listToShow,
                                groupBy: (transaction) {
                                  return formatDate(transaction.timeStamp);
                                },
                                groupSeparatorBuilder: (String date) {
                                  return TransactionMonthSeparator(text: date);
                                },
                                groupComparator: (date1, date2) => 0,
                                itemBuilder: (context, transaction) {
                                  final index = listToShow.indexOf(transaction);
                                  final currentDate =
                                      formatDate(transaction.timeStamp);
                                  var nextDate = '';
                                  if (index != (listToShow.length - 1)) {
                                    nextDate = formatDate(
                                      listToShow[index + 1].timeStamp,
                                    );
                                  }
                                  final removeDividerForLastInGroup =
                                      currentDate != nextDate;

                                  return listToShow.indexOf(transaction) ==
                                          listToShow.length - 1
                                      ? Column(
                                          children: [
                                            TransactionListItem(
                                              transactionListItem: transaction,
                                              removeDivider:
                                                  removeDividerForLastInGroup,
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
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  width: 2,
                                                  color: colors.grey4,
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
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
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 20,
                                                          ),
                                                          child: SizedBox(
                                                            height: 77,
                                                            child: Baseline(
                                                              baseline: 38,
                                                              baselineType:
                                                                  TextBaseline
                                                                      .alphabetic,
                                                              child: Text(
                                                                intl.newsList_wentWrongText,
                                                                style:
                                                                    sBodyText1Style,
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
                                                    name: intl
                                                        .transactionsList_retry,
                                                    onTap: () {
                                                      transactionHistory
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
                                          removeDivider:
                                              removeDividerForLastInGroup,
                                        );
                                },
                              );
                      },
                    )
              : const LoadingSliverList();
        },
      ),
    );
  }

  bool _addBottomPadding(OperationHistory transactionHistory) {
    return (transactionHistory.union != const OperationHistoryUnion.error()) &&
        !transactionHistory.nothingToLoad;
  }
}
