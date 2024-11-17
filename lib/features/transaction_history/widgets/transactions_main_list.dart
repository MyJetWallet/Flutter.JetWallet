import 'dart:async';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../utils/constants.dart';
import '../../wallet/helper/format_date.dart';
import '../../wallet/helper/nft_types.dart';
import 'transaction_list_loading_item.dart';
import 'transaction_month_separator.dart';

class TransactionsMainList extends StatefulWidget {
  const TransactionsMainList({
    super.key,
    this.isRecurring = false,
    this.zeroPadding = false,
    this.symbol,
    this.filter = TransactionType.none,
    this.jwOperationId,
    this.jwOperationPtpManage,
    this.pendingOnly = false,
  });

  final String? symbol;
  final TransactionType filter;
  final bool isRecurring;
  final bool zeroPadding;
  final String? jwOperationId;
  final String? jwOperationPtpManage;
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
        assetId: widget.symbol,
        filter: widget.filter,
        isRecurring: widget.isRecurring,
        jwOperationId: widget.jwOperationId,
        pendingOnly: widget.pendingOnly,
        jwOperationPtpManage: widget.jwOperationPtpManage,
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
                          style: STStyles.header6,
                        ),
                        const SpaceH8(),
                        Text(
                          intl.historyRecurringBuy_text1,
                          style: STStyles.body1Medium.copyWith(
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
                            child: const rive.RiveAnimation.asset(
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
                      key: Key(
                        '${transaction.operationType.name} ^ ${transaction.operationId}}',
                      ),
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
                          source: TransactionItemSource.history,
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
                            child: const rive.RiveAnimation.asset(
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
                            style: STStyles.body1Medium,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SButton.text(
                text: intl.transactionsList_retry,
                callback: () {
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
