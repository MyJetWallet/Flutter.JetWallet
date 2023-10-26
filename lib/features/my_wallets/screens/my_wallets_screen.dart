import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/my_wallets/widgets/actions_my_wallets_row_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/add_wallet_bottom_sheet.dart';
import 'package:jetwallet/features/my_wallets/widgets/assets_list_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/balance_amount_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/change_order_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/my_wallets_header.dart';
import 'package:jetwallet/features/my_wallets/widgets/pending_transactions_widget.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:rive/rive.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'MyWalletsRouter')
class MyWalletsScreen extends StatefulObserverWidget {
  const MyWalletsScreen({super.key});

  @override
  State<MyWalletsScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<MyWalletsScreen> {
  final _controller = ScrollController();
  bool isTopPosition = true;

  final store = getIt.get<MyWalletsSrore>();

  // for analytic
  GlobalHistoryTab historyTab = GlobalHistoryTab.pending;

  @override
  void initState() {
    super.initState();

    sAnalytics.walletsScreenView(
      favouritesAssetsList: List.generate(
        store.currencies.length,
        (index) => store.currencies[index].symbol,
      ),
    );

    _controller.addListener(() {
      if (_controller.position.pixels <= 0) {
        if (!isTopPosition) {
          setState(() {
            isTopPosition = true;
          });
        }
      } else {
        if (isTopPosition) {
          setState(() {
            isTopPosition = false;
          });
        }
      }
    });

    getIt<EventBus>().on<ResetScrollMyWallets>().listen((event) {
      _controller.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPageFrame(
      color: colors.white,
      loaderText: '',
      child: SafeArea(
        child: Column(
          children: [
            if (!store.isReordering)
              MyWalletsHeader(
                isTitleCenter: !store.isReordering && !isTopPosition,
              ),
            Expanded(
              child: CustomRefreshIndicator(
                offsetToArmed: 75,
                onRefresh: () => getIt.get<SignalRService>().forceReconnectSignalR(),
                builder: (
                  BuildContext context,
                  Widget child,
                  IndicatorController controller,
                ) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Opacity(
                        opacity: !controller.isIdle ? 1 : 0,
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget? _) {
                            return SizedBox(
                              height: controller.value * 75,
                              child: Container(
                                width: 24.0,
                                decoration: BoxDecoration(
                                  color: colors.grey5,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const RiveAnimation.asset(
                                  loadingAnimationAsset,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      AnimatedBuilder(
                        builder: (context, _) {
                          return Transform.translate(
                            offset: Offset(
                              0.0,
                              !controller.isIdle ? (controller.value * 75) : 0,
                            ),
                            child: child,
                          );
                        },
                        animation: controller,
                      ),
                    ],
                  );
                },
                child: ColoredBox(
                  color: colors.white,
                  child: CustomScrollView(
                    controller: _controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // SliverPersistentHeader(
                      //   floating: true,
                      //   pinned: !store.isReordering,
                      //   delegate: _SliverAppBarDelegate(
                      //     minHeight: isTopPosition ? 47 : 64,
                      //     maxHeight: isTopPosition ? 47 : 64,
                      //     child: ,
                      //   ),
                      // ),
                      if (store.isReordering)
                        SliverToBoxAdapter(
                          child: MyWalletsHeader(
                            isTitleCenter: !store.isReordering && !isTopPosition,
                          ),
                        ),
                      const SliverToBoxAdapter(child: BalanceAmountWidget()),
                      const SliverToBoxAdapter(child: SpaceH32()),
                      const SliverToBoxAdapter(child: ActionsMyWalletsRowWidget()),
                      const SliverToBoxAdapter(child: SpaceH28()),
                      if (store.countOfPendingTransactions > 0) ...[
                        SliverToBoxAdapter(
                          child: PendingTransactionsWidget(
                            countOfTransactions: store.countOfPendingTransactions,
                            onTap: () {
                              sAnalytics.tapOnTheButtonPendingTransactionsOnWalletsScreen(
                                numberOfPendingTrx: store.countOfPendingTransactions,
                              );
                              if (store.isReordering) {
                                store.endReorderingImmediately();
                              } else {
                                historyTab = GlobalHistoryTab.pending;
                                sRouter
                                    .push(
                                  TransactionHistoryRouter(
                                    initialIndex: 1,
                                    onTabChanged: (index) {
                                      final result = index == 0 ? GlobalHistoryTab.all : GlobalHistoryTab.pending;
                                      setState(() {
                                        historyTab = result;
                                      });
                                    },
                                  ),
                                )
                                    .then(
                                  (value) {
                                    sAnalytics.tapOnTheButtonBackOnGlobalTransactionHistoryScreen(
                                      globalHistoryTab: historyTab,
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        const SliverToBoxAdapter(child: SpaceH10()),
                      ],
                      if (store.isReordering)
                        SliverPersistentHeader(
                          pinned: store.isReordering,
                          delegate: _SliverAppBarDelegate(
                            minHeight: 64,
                            maxHeight: 64,
                            child: ChangeOrderWidget(
                              onPressedDone: store.onEndReordering,
                            ),
                          ),
                        ),
                      const SliverToBoxAdapter(child: AssetsListWidget()),
                      const SliverToBoxAdapter(child: SpaceH16()),
                      if (store.currenciesForSearch.isNotEmpty && !store.isReordering)
                        SliverToBoxAdapter(
                          child: Row(
                            children: [
                              const SpaceW24(),
                              SIconTextButton(
                                onTap: () {
                                  sAnalytics.tapOnTheButtonAddWalletOnWalletsScreen();
                                  showAddWalletBottomSheet(context);
                                },
                                text: intl.my_wallets_add_wallet,
                                icon: SizedBox(
                                  width: 16,
                                  child: SPlusIcon(
                                    color: colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SliverToBoxAdapter(child: SpaceH31()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
