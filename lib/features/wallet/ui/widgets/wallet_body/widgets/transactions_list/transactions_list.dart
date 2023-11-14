import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/transaction_list_item.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../helper/format_date.dart';
import '../loading_sliver_list.dart';
import '../transaction_month_separator.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    super.key,
    this.isRecurring = false,
    this.symbol,
    this.accountId,
    required this.scrollController,
    this.onItemTapLisener,
    this.fromCJAccount = false,
  });

  final ScrollController scrollController;
  final String? symbol;
  final String? accountId;
  final bool isRecurring;
  final void Function(String assetSymbol)? onItemTapLisener;
  final bool fromCJAccount;

  @override
  Widget build(BuildContext context) {
    return Provider<OperationHistory>(
      create: (context) => OperationHistory(
        symbol,
        null,
        isRecurring,
        null,
        false,
        accountId,
      )..initOperationHistory(),
      builder: (context, child) => _TransactionsListBody(
        scrollController: scrollController,
        symbol: symbol,
        isRecurring: isRecurring,
        onItemTapLisener: onItemTapLisener,
        fromCJAccount: fromCJAccount,
        accountId: accountId,
      ),
      //dispose: (context, value) => value.stopTimer(),
    );
  }
}

class _TransactionsListBody extends StatefulObserverWidget {
  const _TransactionsListBody({
    this.isRecurring = false,
    this.symbol,
    this.accountId,
    required this.scrollController,
    this.onItemTapLisener,
    this.fromCJAccount = false,
  });

  final ScrollController scrollController;
  final String? symbol;
  final String? accountId;
  final bool isRecurring;
  final void Function(String assetSymbol)? onItemTapLisener;
  final bool fromCJAccount;

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

    final screenHeight = MediaQuery.of(context).size.height;
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
                  child: SizedBox(
                    height: widget.symbol != null
                        ? screenHeight - screenHeight * 0.369 - 227
                        : screenHeight - screenHeight * 0.369,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          smileAsset,
                          width: 48,
                          height: 48,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: Text(
                            intl.wallet_simple_account_empty,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: sSubtitle2Style.copyWith(
                              color: sKit.colors.grey2,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                      source:
                          widget.fromCJAccount ? TransactionItemSource.eurAccount : TransactionItemSource.cryptoAccount,
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
                                source: widget.fromCJAccount
                                    ? TransactionItemSource.eurAccount
                                    : TransactionItemSource.cryptoAccount,
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
                            source: widget.fromCJAccount
                                ? TransactionItemSource.eurAccount
                                : TransactionItemSource.cryptoAccount,
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
                                source: widget.fromCJAccount
                                    ? TransactionItemSource.eurAccount
                                    : TransactionItemSource.cryptoAccount,
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
                            onItemTapLisener: widget.onItemTapLisener,
                            fromCJAccount: widget.fromCJAccount,
                            source: widget.fromCJAccount
                                ? TransactionItemSource.eurAccount
                                : TransactionItemSource.cryptoAccount,
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
