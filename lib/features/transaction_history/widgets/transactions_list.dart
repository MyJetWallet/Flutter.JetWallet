import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../wallet/helper/format_date.dart';
import 'loading_sliver_list.dart';
import 'transaction_month_separator.dart';

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
  });

  final ScrollController scrollController;
  final String? symbol;
  final String? jarId;
  final String? accountId;
  final bool isRecurring;
  final void Function(String assetSymbol)? onItemTapLisener;
  final Function(String reason)? onError;
  final bool fromCJAccount;
  final bool isSimpleCard;
  final TransactionItemSource source;

  @override
  Widget build(BuildContext context) {
    return Provider<OperationHistory>(
      create: (context) => OperationHistory(
        symbol,
        jarId,
        null,
        isRecurring,
        null,
        false,
        accountId,
        isSimpleCard,
        onError,
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
          Widget body;

          if (listToShow.isEmpty) {
            body = SliverToBoxAdapter(
              child: (widget.fromCJAccount || widget.jarId != null)
                  ? widget.jarId == null
                      ? SPlaceholder(
                          size: SPlaceholderSize.l,
                          text: intl.wallet_simple_account_empty,
                        )
                      : Column(
                          children: [
                            Container(
                              height: 32.0,
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                left: 24.0,
                                right: 24.0,
                                bottom: 24.0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 6.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: SColorsLight().gray2,
                              ),
                              child: _buildWithdrawnTotally(listToShow),
                            ),
                            SPlaceholder(
                              size: SPlaceholderSize.l,
                              text: intl.wallet_simple_account_empty,
                            ),
                          ],
                        )
                  : SizedBox(
                      height: widget.symbol != null
                          ? screenHeight - screenHeight * 0.369 - 227
                          : screenHeight - screenHeight * 0.369,
                      child: Column(
                        mainAxisAlignment: widget.isSimpleCard ? MainAxisAlignment.start : MainAxisAlignment.center,
                        children: [
                          if (widget.isSimpleCard) const SpaceH45(),
                          Image.asset(
                            smileAsset,
                            width: 36,
                            height: 36,
                          ),
                          const SpaceH6(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            child: Text(
                              intl.wallet_simple_account_empty,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: STStyles.subtitle2.copyWith(
                                color: sKit.colors.grey2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          } else {
            if (widget.jarId != null) {
              body = SliverToBoxAdapter(
                child: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        height: 32.0,
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          bottom: 24.0,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: SColorsLight().gray2,
                        ),
                        child: _buildWithdrawnTotally(listToShow),
                      ),
                    ),
                    SliverGroupedListView<OperationHistoryItem, String>(
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
                    ),
                  ],
                ),
              );
            } else {
              body = SliverGroupedListView<OperationHistoryItem, String>(
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
            }
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

  Widget _buildWithdrawnTotally(List<OperationHistoryItem> listToShow) {
    final withdrawalList = listToShow
        .where((item) => item.operationType == OperationType.jarWithdrawal && item.status == Status.completed);
    if (withdrawalList.isNotEmpty) {
      final totalWithdraw = withdrawalList.map((item) => item.balanceChange).reduce((a, b) => a + b);

      final currency = currencyFrom(
        sSignalRModules.currenciesWithHiddenList,
        'USDT',
      );

      return RichText(
        text: TextSpan(
          text: totalWithdraw.abs().toFormatCount(
                accuracy: currency.accuracy,
                symbol: currency.symbol,
              ),
          style: STStyles.subtitle2.copyWith(
            color: SColorsLight().black,
          ),
          children: [
            TextSpan(
              text: intl.jar_withdrawn_totally,
              style: STStyles.body2Medium.copyWith(
                color: SColorsLight().gray10,
              ),
            ),
          ],
        ),
      );
    } else {
      return Text(
        intl.jar_transactions_empty,
        style: STStyles.body2Medium.copyWith(
          color: SColorsLight().gray10,
        ),
      );
    }
  }
}
