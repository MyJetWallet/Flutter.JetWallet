import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../shared/helpers/contains_single_element.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../screens/market/model/market_item_model.dart';
import '../../../../screens/market/provider/market_items_pod.dart';
import '../../../../screens/market/view/components/fade_on_scroll.dart';
import '../helper/assets_with_balance_from.dart';
import '../helper/format_date.dart';
import '../notifier/operation_history_notipod.dart';
import 'components/action_button.dart';
import 'components/wallets_body/components/card_block/components/wallet_card.dart';
import 'components/wallets_body/components/card_block/components/wallet_card_collapsed.dart';
import 'components/wallets_body/components/transactions_list_item/transaction_list_item.dart';

class Wallet extends StatefulHookWidget {
  const Wallet({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  static void push({
    required BuildContext context,
    required String assetId,
  }) {
    navigatorPush(
      context,
      Wallet(
        assetId: assetId,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _WalletState();
}

class _WalletState extends State<Wallet>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late AnimationController animationController;
  final PageController _pageController = PageController();

  @override
  void initState() {
    // final transactionHistoryN = context.read(
    //   operationHistoryNotipod.notifier,
    // );
    // final itemsWithBalance = marketItemsWithBalanceFrom(
    //   context.read(marketItemsPod),
    //   widget.assetId,
    // );
    //
    // for (final item in itemsWithBalance) {
    //   transactionHistoryN.initOperationHistory(
    //     item.associateAsset,
    //   );
    // }
    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final itemsWithBalance = marketItemsWithBalanceFrom(
      useProvider(marketItemsPod),
      widget.assetId,
    );
    final transactionHistoryN = useProvider(
      operationHistoryNotipod.notifier,
    );
    final transactionHistory = useProvider(operationHistoryNotipod);
    useListenable(animationController);

    return Scaffold(
      bottomNavigationBar: ActionButton(
        transitionAnimationController: animationController,
      ),
      body: Material(
        color: Colors.transparent,
        child: SShadeAnimationStack(
          controller: animationController,
          // child: Container(),
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  transactionHistoryN.initOperationHistory(
                    itemsWithBalance[index].associateAsset,
                  );
                },
                children: [
                  for (final item in itemsWithBalance)
                    WalletTest(
                      item: item,
                      operations:
                          transactionHistory[itemsWithBalance.indexOf(item)],
                    ),
                ],
              ),
              if (!containsSingleElement(itemsWithBalance))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final item in itemsWithBalance)
                      Container(
                        height: 2,
                        width: 8,
                        margin: const EdgeInsets.only(right: 2, top: 118),
                        decoration: BoxDecoration(
                          color:
                              itemsWithBalance.indexOf(item) == _currentPage()
                                  ? Colors.black
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  int _currentPage() =>
      (_pageController.hasClients ? (_pageController.page ?? 0) : 0).toInt();

  @override
  bool get wantKeepAlive => true;
}

class WalletTest extends StatefulHookWidget {
  const WalletTest({
    Key? key,
    required this.item,
    required this.operations,
  }) : super(key: key);

  final MarketItemModel item;
  final List<OperationHistoryItem> operations;

  @override
  State<StatefulWidget> createState() => _WalletTestState();
}

class _WalletTestState extends State<WalletTest>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var walletBackground = 'assets/images/green_wallet_gradient.svg';

    if (!widget.item.isGrowing) {
      walletBackground = 'assets/images/red_wallet_gradient.svg';
    }

    return Scaffold(
      body: Material(
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
                    assetId: widget.item.associateAsset,
                    walletBackground: walletBackground,
                  ),
                  fadeOutWidget: WalletCard(
                    assetId: widget.item.associateAsset,
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
                          title: '${widget.item.name} wallet',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverGroupedListView<OperationHistoryItem, String>(
                elements: widget.operations,
                // controller: _scrollController,
                groupBy: (transaction) {
                  return formatDate(transaction.timeStamp);
                },
                groupSeparatorBuilder: (String date) {
                  return const SDivider();
                },
                groupComparator: (date1, date2) => 0,
                itemBuilder: (context, transaction) {
                  if (widget.operations.indexOf(transaction) == 0) {
                    return SPaddingH24(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SpaceH36(),
                          Text(
                            '${widget.item.name} transactions',
                            style: sTextH4Style,
                          ),
                          const SpaceH15(),
                          TransactionListItem(
                            transactionListItem: transaction,
                          )
                        ],
                      ),
                    );
                  } else if (widget.operations.indexOf(transaction) ==
                      widget.operations.length - 1) {
                    return SPaddingH24(
                      child: TransactionListItem(
                        transactionListItem: transaction,
                        removeDivider: true,
                      ),
                    );
                  } else {
                    return SPaddingH24(
                      child: TransactionListItem(
                        transactionListItem: transaction,
                      ),
                    );
                  }
                },
              )
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
