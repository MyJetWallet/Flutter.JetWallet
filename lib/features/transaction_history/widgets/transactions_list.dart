import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../wallet/helper/format_date.dart';
import 'loading_sliver_list.dart';
import 'transaction_month_separator.dart';

enum TransactionListMode { full, preview }

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    super.key,
    this.isRecurring = false,
    this.symbol,
    this.jarId,
    this.accountId,
    required this.scrollController,
    this.onItemTapLisener,
    this.fromCJAccount = false,
    this.isSimpleCard = false,
    required this.source,
    this.onError,
    this.onData,
    this.mode = TransactionListMode.full,
  });

  final ScrollController scrollController;
  final String? symbol;
  final String? jarId;
  final String? accountId;
  final bool isRecurring;
  final void Function(String assetSymbol)? onItemTapLisener;
  final Function(String reason)? onError;
  final Function(List<OperationHistoryItem> items)? onData;
  final bool fromCJAccount;
  final bool isSimpleCard;
  final TransactionItemSource source;
  final TransactionListMode mode;

  @override
  Widget build(BuildContext context) {
    return Provider<OperationHistory>(
      create: (context) => OperationHistory(
        assetId: symbol,
        isRecurring: isRecurring,
        accountId: accountId,
        isCard: isSimpleCard,
        onError: onError,
        onData: onData,
        mode: mode,
        jarId,
        null,
        null,
        false,
        null,
      )..initOperationHistory(),
      builder: (context, child) => _TransactionsListBody(
        scrollController: scrollController,
        symbol: symbol,
        jarId: jarId,
        isRecurring: isRecurring,
        onItemTapLisener: onItemTapLisener,
        fromCJAccount: fromCJAccount,
        accountId: accountId,
        source: source,
        isSimpleCard: isSimpleCard,
      ),
      //dispose: (context, value) => value.stopTimer(),
    );
  }
}

class _TransactionsListBody extends StatefulObserverWidget {
  const _TransactionsListBody({
    this.isRecurring = false,
    this.symbol,
    this.jarId,
    this.accountId,
    required this.scrollController,
    this.onItemTapLisener,
    this.fromCJAccount = false,
    this.isSimpleCard = false,
    required this.source,
  });

  final ScrollController scrollController;
  final String? symbol;
  final String? jarId;
  final String? accountId;
  final bool isRecurring;
  final bool isSimpleCard;
  final void Function(String assetSymbol)? onItemTapLisener;
  final bool fromCJAccount;
  final TransactionItemSource source;

  @override
  State<StatefulWidget> createState() => _TransactionsListBodyState();
}

class _TransactionsListBodyState extends State<_TransactionsListBody> {
  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent <= widget.scrollController.offset) {
        if (OperationHistory.of(context).union == const OperationHistoryUnion.loaded() &&
            !OperationHistory.of(context).nothingToLoad) {
          OperationHistory.of(context).operationHistory(widget.symbol, accountId: widget.accountId);
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

    final listToShow = widget.isRecurring
        ? OperationHistory.of(context)
            .operationHistoryItems
            .where(
              (i) => i.operationType == OperationType.recurringBuy,
            )
            .toList()
        : OperationHistory.of(context).operationHistoryItems;

    return SliverPadding(
      key: UniqueKey(),
      padding: EdgeInsets.only(
        top: OperationHistory.of(context).union != const OperationHistoryUnion.error() ? 15 : 0,
        bottom: _addBottomPadding() ? 72 : 0,
      ),
      sliver: OperationHistory.of(context).union.when(
        loaded: () {
          return listToShow.isEmpty
              ? SliverToBoxAdapter(
                  child: SPlaceholder(
                    size: SPlaceholderSize.l,
                    text: intl.wallet_simple_account_empty,
                  ),
                )
              : SliverGroupedListView<OperationHistoryItem, String>(
                  elements: listToShow,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  sort: false,
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(text: date);
                  },
                  itemBuilder: (context, transaction) {
                    return TransactionListItem(
                      transactionListItem: transaction,
                      onItemTapLisener: widget.onItemTapLisener,
                      fromCJAccount: widget.fromCJAccount,
                      source: widget.source,
                    );
                  },
                );
              },
            );
          }

          return body;
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
                                OperationHistory.of(context).initOperationHistory();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : SliverGroupedListView<OperationHistoryItem, String>(
                  elements: listToShow,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(text: date);
                  },
                  groupComparator: (date1, date2) => 0,
                  itemBuilder: (context, transaction) {
                    return listToShow.indexOf(transaction) == listToShow.length - 1
                        ? Column(
                            children: [
                              TransactionListItem(
                                transactionListItem: transaction,
                                onItemTapLisener: widget.onItemTapLisener,
                                fromCJAccount: widget.fromCJAccount,
                                source: widget.source,
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
                                        OperationHistory.of(context).operationHistory(
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
                            onItemTapLisener: widget.onItemTapLisener,
                            fromCJAccount: widget.fromCJAccount,
                            source: widget.source,
                          );
                  },
                );
        },
        loading: () {
          return listToShow.isEmpty
              ? const LoadingSliverList()
              : SliverGroupedListView<OperationHistoryItem, String>(
                  elements: listToShow,
                  groupBy: (transaction) {
                    return formatDate(transaction.timeStamp);
                  },
                  sort: false,
                  groupSeparatorBuilder: (String date) {
                    return TransactionMonthSeparator(text: date);
                  },
                  itemBuilder: (context, transaction) {
                    return listToShow.indexOf(transaction) == listToShow.length - 1
                        ? Column(
                            children: [
                              TransactionListItem(
                                transactionListItem: transaction,
                                onItemTapLisener: widget.onItemTapLisener,
                                fromCJAccount: widget.fromCJAccount,
                                source: widget.source,
                              ),
                              const SpaceH24(),
                              Container(
                                width: 24.0,
                                height: 24.0,
                                decoration: BoxDecoration(
                                  color: colors.grey5,
                                  shape: BoxShape.circle,
                                ),
                                child: const rive.RiveAnimation.asset(
                                  loadingAnimationAsset,
                                ),
                              ),
                            ],
                          )
                        : TransactionListItem(
                            transactionListItem: transaction,
                            onItemTapLisener: widget.onItemTapLisener,
                            fromCJAccount: widget.fromCJAccount,
                            source: widget.source,
                          );
                  },
                );
        },
      ),
    );
  }

  bool _addBottomPadding() {
    return (OperationHistory.of(context).union != const OperationHistoryUnion.error()) &&
        !OperationHistory.of(context).nothingToLoad;
  }
}
