import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/features/wallet/notifier/operation_history_state.dart';
import 'package:jetwallet/app/shared/features/wallet/view/components/wallet_body/components/loading_sliver_list.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../shared/constants.dart';
import '../../../../../../screens/market/view/components/fade_on_scroll.dart';
import '../../../../../models/currency_model.dart';
import '../../../helper/format_date.dart';
import '../../../notifier/operation_history_notipod.dart';
import '../../../notifier/operation_history_union.dart';
import '../../../provider/operation_history_fpod.dart';
import 'components/card_block/components/wallet_card.dart';
import 'components/card_block/components/wallet_card_collapsed.dart';
import 'components/transaction_month_separator.dart';
import 'components/transactions_list_item/transaction_list_item.dart';

// TODO: refactor this widget
class WalletBody extends StatefulHookWidget {
  const WalletBody({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CurrencyModel item;

  @override
  State<StatefulWidget> createState() => _WalletTestState();
}

class _WalletTestState extends State<WalletBody>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        final transactionHistory = context.read(
          operationHistoryNotipod(
            widget.item.assetId,
          ),
        );

        if (transactionHistory.union == const OperationHistoryUnion.loaded() &&
            !transactionHistory.nothingToLoad) {
          final transactionHistoryN = context.read(
            operationHistoryNotipod(
              widget.item.assetId,
            ).notifier,
          );

          transactionHistoryN.operationHistory(widget.item.assetId);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colors = useProvider(sColorPod);
    final initTransactionHistory = useProvider(
      operationHistoryInitFpod(
        widget.item.assetId,
      ),
    );
    final transactionHistoryN = useProvider(
      operationHistoryNotipod(
        widget.item.assetId,
      ).notifier,
    );
    final transactionHistory = useProvider(
      operationHistoryNotipod(
        widget.item.assetId,
      ),
    );
    final screenHeight = MediaQuery.of(context).size.height;

    var walletBackground = walletGreenBackgroundImageAsset;

    if (!widget.item.isGrowing) {
      walletBackground = walletRedBackgroundImageAsset;
    }

    return Scaffold(
      body: Material(
        color: colors.white,
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            _snapAppbar();
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                pinned: true,
                stretch: true,
                elevation: 0,
                expandedHeight: 270,
                collapsedHeight: 200,
                automaticallyImplyLeading: false,
                primary: false,
                flexibleSpace: FadeOnScroll(
                  scrollController: _scrollController,
                  fullOpacityOffset: 33,
                  fadeInWidget: WalletCardCollapsed(
                    assetId: widget.item.assetId,
                  ),
                  fadeOutWidget: WalletCard(
                    assetId: widget.item.assetId,
                  ),
                  permanentWidget: Stack(
                    children: [
                      SvgPicture.asset(
                        walletBackground,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      SPaddingH24(
                        child: SSmallHeader(
                          title: '${widget.item.description} wallet',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SPaddingH24(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpaceH36(),
                      Text(
                        '${widget.item.description} transactions',
                        style: sTextH4Style,
                      ),
                      if (transactionHistory.union !=
                          const OperationHistoryUnion.error())
                        const SpaceH15(),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: _addBottomPadding(transactionHistory) ? 72 : 0,
                ),
                sliver: initTransactionHistory.when(
                  data: (_) {
                    return transactionHistory.union.when(
                      loading: () {
                        if (transactionHistory.operationHistoryItems.isEmpty) {
                          return const LoadingSliverList();
                        } else {
                          return SliverGroupedListView<OperationHistoryItem,
                              String>(
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
                              final index = transactionHistory
                                  .operationHistoryItems
                                  .indexOf(transaction);
                              final currentDate =
                                  formatDate(transaction.timeStamp);
                              var nextDate = '';
                              if (index !=
                                  (transactionHistory
                                          .operationHistoryItems.length -
                                      1)) {
                                nextDate = formatDate(
                                  transactionHistory
                                      .operationHistoryItems[index + 1]
                                      .timeStamp,
                                );
                              }
                              final removeDividerForLastInGroup =
                                  currentDate != nextDate;

                              if (transactionHistory.operationHistoryItems
                                      .indexOf(transaction) ==
                                  transactionHistory
                                          .operationHistoryItems.length -
                                      1) {
                                return Column(
                                  children: [
                                    SPaddingH24(
                                      child: TransactionListItem(
                                        transactionListItem: transaction,
                                        removeDivider:
                                            removeDividerForLastInGroup,
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
                        return SliverGroupedListView<OperationHistoryItem,
                            String>(
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
                            final index = transactionHistory
                                .operationHistoryItems
                                .indexOf(transaction);
                            final currentDate =
                                formatDate(transaction.timeStamp);
                            var nextDate = '';
                            if (index !=
                                (transactionHistory
                                        .operationHistoryItems.length -
                                    1)) {
                              nextDate = formatDate(
                                transactionHistory
                                    .operationHistoryItems[index + 1].timeStamp,
                              );
                            }
                            final removeDividerForLastInGroup =
                                currentDate != nextDate;

                            if (transactionHistory.operationHistoryItems
                                    .indexOf(transaction) ==
                                transactionHistory
                                        .operationHistoryItems.length -
                                    1) {
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
                                    top: screenHeight - (screenHeight * 0.7133),
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
                                          transactionHistoryN
                                              .initOperationHistory();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SliverGroupedListView<OperationHistoryItem,
                              String>(
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
                              final index = transactionHistory
                                  .operationHistoryItems
                                  .indexOf(transaction);
                              final currentDate =
                                  formatDate(transaction.timeStamp);
                              var nextDate = '';
                              if (index !=
                                  (transactionHistory
                                          .operationHistoryItems.length -
                                      1)) {
                                nextDate = formatDate(
                                  transactionHistory
                                      .operationHistoryItems[index + 1]
                                      .timeStamp,
                                );
                              }
                              final removeDividerForLastInGroup =
                                  currentDate != nextDate;

                              if (transactionHistory.operationHistoryItems
                                      .indexOf(transaction) ==
                                  transactionHistory
                                          .operationHistoryItems.length -
                                      1) {
                                return Column(
                                  children: [
                                    SPaddingH24(
                                      child: TransactionListItem(
                                        transactionListItem: transaction,
                                        removeDivider:
                                            removeDividerForLastInGroup,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 20,
                                                  ),
                                                  child: SizedBox(
                                                    height: 77,
                                                    child: Baseline(
                                                      baseline: 38,
                                                      baselineType: TextBaseline
                                                          .alphabetic,
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
                                              transactionHistoryN
                                                  .operationHistory(
                                                widget.item.assetId,
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
                              top: screenHeight - (screenHeight * 0.7133),
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
                                            baselineType:
                                                TextBaseline.alphabetic,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _snapAppbar() {
    const scrollDistance = 270 - 200;

    if (_scrollController.offset > 0 &&
        _scrollController.offset < scrollDistance) {
      final num snapOffset =
          _scrollController.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(
        () => _scrollController.animateTo(
          snapOffset.toDouble(),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
        ),
      );
    }
  }

  bool _addBottomPadding(OperationHistoryState transactionHistory) {
    return (transactionHistory.union != const OperationHistoryUnion.error()) &&
        !transactionHistory.nothingToLoad;
  }

  @override
  bool get wantKeepAlive => true;
}
