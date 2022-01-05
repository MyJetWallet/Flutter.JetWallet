import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../screens/market/view/components/fade_on_scroll.dart';
import '../../../../../models/currency_model.dart';
import '../../../helper/format_date.dart';
import '../../../notifier/operation_history_notipod.dart';
import '../../../provider/operation_history_fpod.dart';
import 'components/card_block/components/wallet_card.dart';
import 'components/card_block/components/wallet_card_collapsed.dart';
import 'components/transactions_list_item/transaction_list_item.dart';
import 'components/transactions_list_item/transaction_list_loading_item.dart';

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
        final transactionHistoryN = context.read(
          operationHistoryNotipod(widget.item.assetId).notifier,
        );

        transactionHistoryN.operationHistory(widget.item.assetId);
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

    var walletBackground = 'assets/images/green_wallet_gradient.svg';

    if (!widget.item.isGrowing) {
      walletBackground = 'assets/images/red_wallet_gradient.svg';
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
                snap: true,
                floating: true,
                elevation: 0,
                expandedHeight: 270,
                collapsedHeight: 204,
                automaticallyImplyLeading: false,
                primary: false,
                flexibleSpace: FadeOnScroll(
                  scrollController: _scrollController,
                  fullOpacityOffset: 33,
                  fadeInWidget: WalletCardCollapsed(
                    assetId: widget.item.assetId,
                    walletBackground: walletBackground,
                  ),
                  fadeOutWidget: WalletCard(
                    assetId: widget.item.assetId,
                    walletBackground: walletBackground,
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
              initTransactionHistory.when(
                data: (_) {
                  return transactionHistory.union.when(
                    loading: () {
                      return SliverGroupedListView<OperationHistoryItem,
                          String>(
                        elements: transactionHistory.operationHistoryItems,
                        groupBy: (transaction) {
                          return formatDate(transaction.timeStamp);
                        },
                        groupSeparatorBuilder: (String date) {
                          if (date ==
                              formatDate(
                                transactionHistory
                                    .operationHistoryItems.first.timeStamp,
                              )) {
                            return const SizedBox();
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: SDivider(),
                            );
                          }
                        },
                        groupComparator: (date1, date2) => 0,
                        itemBuilder: (context, transaction) {
                          final index = transactionHistory.operationHistoryItems
                              .indexOf(transaction);
                          final currentDate = formatDate(transaction.timeStamp);
                          var nextDate = '';
                          if (index !=
                              (transactionHistory.operationHistoryItems.length -
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
                              0) {
                            return SPaddingH24(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SpaceH36(),
                                  Text(
                                    '${widget.item.description} transactions',
                                    style: sTextH4Style,
                                  ),
                                  const SpaceH15(),
                                  TransactionListItem(
                                    transactionListItem: transaction,
                                    removeDivider: removeDividerForLastInGroup,
                                  ),
                                ],
                              ),
                            );
                          } else if (transactionHistory.operationHistoryItems
                                  .indexOf(transaction) ==
                              transactionHistory.operationHistoryItems.length -
                                  1) {
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
                                const SpaceH24(),
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
                    },
                    loaded: () {
                      return SliverGroupedListView<OperationHistoryItem,
                          String>(
                        elements: transactionHistory.operationHistoryItems,
                        groupBy: (transaction) {
                          return formatDate(transaction.timeStamp);
                        },
                        groupSeparatorBuilder: (String date) {
                          if (date ==
                              formatDate(
                                transactionHistory
                                    .operationHistoryItems.first.timeStamp,
                              )) {
                            return const SizedBox();
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: SDivider(),
                            );
                          }
                        },
                        groupComparator: (date1, date2) => 0,
                        itemBuilder: (context, transaction) {
                          final index = transactionHistory.operationHistoryItems
                              .indexOf(transaction);
                          final currentDate = formatDate(transaction.timeStamp);
                          var nextDate = '';
                          if (index !=
                              (transactionHistory.operationHistoryItems.length -
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
                              0) {
                            return SPaddingH24(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SpaceH36(),
                                  Text(
                                    '${widget.item.description} transactions',
                                    style: sTextH4Style,
                                  ),
                                  const SpaceH15(),
                                  TransactionListItem(
                                    transactionListItem: transaction,
                                    removeDivider: transactionHistory
                                                .operationHistoryItems.length ==
                                            1 ||
                                        removeDividerForLastInGroup,
                                  )
                                ],
                              ),
                            );
                          } else if (transactionHistory.operationHistoryItems
                                  .indexOf(transaction) ==
                              transactionHistory.operationHistoryItems.length -
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
                              SPaddingH24(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SpaceH36(),
                                    Text(
                                      '${widget.item.description} transactions',
                                      style: sTextH4Style,
                                    ),
                                  ],
                                ),
                              ),
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
                            if (date ==
                                formatDate(
                                  transactionHistory
                                      .operationHistoryItems.first.timeStamp,
                                )) {
                              return const SizedBox();
                            } else {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: SDivider(),
                              );
                            }
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
                                0) {
                              return SPaddingH24(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SpaceH36(),
                                    Text(
                                      '${widget.item.description} transactions',
                                      style: sTextH4Style,
                                    ),
                                    const SpaceH15(),
                                    TransactionListItem(
                                      transactionListItem: transaction,
                                      removeDivider:
                                          removeDividerForLastInGroup,
                                    ),
                                  ],
                                ),
                              );
                            } else if (transactionHistory.operationHistoryItems
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
                                            transactionHistoryN
                                                .operationHistory(
                                              widget.item.assetId,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SpaceH24(),
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
                loading: () {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final isFirst = index == 0;
                        final removeDivider = index == 4;

                        if (isFirst) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SpaceH36(),
                              SPaddingH24(
                                child: Text(
                                  '${widget.item.description} transactions',
                                  style: sTextH4Style,
                                ),
                              ),
                              const SpaceH15(),
                              TransactionListLoadingItem(
                                removeDivider: removeDivider,
                              ),
                            ],
                          );
                        } else {
                          return TransactionListLoadingItem(
                            removeDivider: removeDivider,
                          );
                        }
                      },
                      childCount: 5,
                    ),
                  );
                },
                error: (_, __) {
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        SPaddingH24(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SpaceH36(),
                              Text(
                                '${widget.item.description} transactions',
                                style: sTextH4Style,
                              ),
                            ],
                          ),
                        ),
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
            ],
          ),
        ),
      ),
    );
  }

  void _snapAppbar() {
    const scrollDistance = 270 - 204;

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

  @override
  bool get wantKeepAlive => true;
}
