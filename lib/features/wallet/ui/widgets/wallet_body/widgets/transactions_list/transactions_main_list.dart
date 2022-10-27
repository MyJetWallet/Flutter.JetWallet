import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/transaction_list_item.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../helper/format_date.dart';
import '../../../../../helper/nft_types.dart';
import '../transaction_month_separator.dart';
import '../transactions_list_item/transaction_list_loading_item.dart';

class TransactionsMainList extends StatelessWidget {
  const TransactionsMainList({
    super.key,
    this.isRecurring = false,
    this.symbol,
    this.filter = TransactionType.none,
    required this.scrollController,
  });

  final ScrollController scrollController;
  final String? symbol;
  final TransactionType filter;
  final bool isRecurring;

  @override
  Widget build(BuildContext context) {
    return Provider<OperationHistory>(
      create: (context) => OperationHistory(symbol)..initOperationHistory(),
      builder: (context, child) => _TransactionsListBody(
        scrollController: scrollController,
        symbol: symbol,
        isRecurring: isRecurring,
        filter: filter,
      ),
    );
  }
}

class _TransactionsListBody extends StatefulObserverWidget {
  const _TransactionsListBody({
    Key? key,
    this.isRecurring = false,
    this.filter = TransactionType.none,
    this.symbol,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;
  final String? symbol;
  final bool isRecurring;
  final TransactionType filter;

  @override
  State<StatefulWidget> createState() => _TransactionsListBodyState();
}

class _TransactionsListBodyState extends State<_TransactionsListBody> {
  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent ==
          widget.scrollController.offset) {
        if (OperationHistory.of(context).union ==
                const OperationHistoryUnion.loaded() &&
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
        final listToShow = widget.isRecurring
            ? OperationHistory.of(context)
            .operationHistoryItems
            .where(
              (i) => i.operationType == OperationType.recurringBuy,
        )
            .toList()
            : widget.filter == TransactionType.crypto
            ? OperationHistory.of(context)
            .operationHistoryItems
            .where(
              (i) => !nftTypes.contains(i.operationType),
        ).toList()
            : widget.filter == TransactionType.nft
            ? OperationHistory.of(context)
            .operationHistoryItems
            .where(
              (i) => nftTypes.contains(i.operationType),
        ).toList()
            : OperationHistory.of(context).operationHistoryItems;

        if (!OperationHistory.of(context).nothingToLoad && listToShow.length < 20) {
          OperationHistory.of(context).operationHistory(widget.symbol);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final screenHeight = MediaQuery.of(context).size.height;

    final listToShow = widget.isRecurring
        ? OperationHistory.of(context)
            .operationHistoryItems
            .where(
              (i) => i.operationType == OperationType.recurringBuy,
            )
            .toList()
        : widget.filter == TransactionType.crypto
        ? OperationHistory.of(context)
          .operationHistoryItems
          .where(
            (i) => !nftTypes.contains(i.operationType),
          ).toList()
        : widget.filter == TransactionType.nft
        ? OperationHistory.of(context)
          .operationHistoryItems
          .where(
            (i) => nftTypes.contains(i.operationType),
          ).toList()
        : OperationHistory.of(context).operationHistoryItems;

    return Padding(
      padding: EdgeInsets.only(
        top: OperationHistory.of(context).union !=
                const OperationHistoryUnion.error()
            ? 15
            : 0,
        bottom: _addBottomPadding() ? 72 : 0,
      ),
      child: OperationHistory.of(context).union.when(
        loaded: () {
          return listToShow.isEmpty
            ? SizedBox(
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
            )
            : GroupedListView<OperationHistoryItem, String>(
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
                final currentDate = formatDate(transaction.timeStamp);
                var nextDate = '';
                if (index != (listToShow.length - 1)) {
                  nextDate = formatDate(listToShow[index + 1].timeStamp);
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
          return listToShow.isEmpty
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
                final currentDate = formatDate(transaction.timeStamp);
                var nextDate = '';
                if (index != (listToShow.length - 1)) {
                  nextDate = formatDate(listToShow[index + 1].timeStamp);
                }
                final removeDividerForLastInGroup = currentDate != nextDate;

                return listToShow.indexOf(transaction) ==
                        listToShow.length - 1
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
          return listToShow.isEmpty
            ? Column(
              children: const [
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
            )
            : GroupedListView<OperationHistoryItem, String>(
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
                final currentDate = formatDate(transaction.timeStamp);
                var nextDate = '';
                if (index != (listToShow.length - 1)) {
                  nextDate = formatDate(listToShow[index + 1].timeStamp);
                }
                final removeDividerForLastInGroup = currentDate != nextDate;

                return listToShow.indexOf(transaction) ==
                      listToShow.length - 1
                  ? Column(
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
                  )
                : TransactionListItem(
                  transactionListItem: transaction,
                  removeDivider: removeDividerForLastInGroup,
                );
              },
            );
        },
      ),
    );
  }

  bool _addBottomPadding() {
    return (OperationHistory.of(context).union !=
            const OperationHistoryUnion.error()) &&
        !OperationHistory.of(context).nothingToLoad;
  }
}
