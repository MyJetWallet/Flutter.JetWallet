import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/my_wallets/widgets/actions_my_wallets_row_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/add_wallet_bottom_sheet.dart';
import 'package:jetwallet/features/my_wallets/widgets/balance_amount_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/change_order_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/get_account_button.dart';
import 'package:jetwallet/features/my_wallets/widgets/my_wallets_asset_item.dart';
import 'package:jetwallet/features/my_wallets/widgets/my_wallets_header.dart';
import 'package:jetwallet/features/my_wallets/widgets/pending_transactions_widget.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:rive/rive.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/delete_asset/simple_delete_asset.dart';
import 'package:simple_kit/modules/icons/24x24/public/start_reorder/simple_start_reorder_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../core/services/user_info/user_info_service.dart';
import '../../../utils/helpers/check_kyc_status.dart';
import '../../kyc/kyc_service.dart';
import '../../simple_card/ui/widgets/get_card_banner.dart';

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
    final userInfo = getIt.get<UserInfoService>();
    final kycState = getIt.get<KycService>();

    final list = slidableItems();

    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        _OnlyOnePointerRecognizer: GestureRecognizerFactoryWithHandlers<_OnlyOnePointerRecognizer>(
          () => _OnlyOnePointerRecognizer(),
          (_OnlyOnePointerRecognizer instance) {},
        ),
      },
      child: SlidableAutoCloseBehavior(
        child: SPageFrame(
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
                          if (
                            userInfo.isSimpleCardAvailable &&
                            (sSignalRModules.bankingProfileData
                                ?.banking?.cards
                                ?.length ?? 0) < (sSignalRModules
                                .bankingProfileData
                                ?.availableCardsCount ?? 1) &&
                            checkKycPassed(
                              kycState.depositStatus,
                              kycState.tradeStatus,
                              kycState.withdrawalStatus,
                            )
                          )
                            const SliverToBoxAdapter(child: GetCardBanner()),
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
                          SliverReorderableList(
                            proxyDecorator: _proxyDecorator,
                            onReorder: (int oldIndex, int newIndex) {
                              store.onReorder(oldIndex, newIndex);
                              setState(() {});
                            },
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return ReorderableDelayedDragStartListener(
                                key: list[index].key,
                                enabled: store.isReordering,
                                index: index,
                                child: list[index],
                              );
                            },
                          ),
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
        ),
      ),
    );
  }

  List<Widget> slidableItems() {
    final colors = sKit.colors;
    final list = <Widget>[];

    for (var index = 0; index < store.currencies.length; index += 1) {
      var skip = false;

      if (store.currencies[index].symbol == 'EUR') {
        if (store.buttonStatus == BankingShowState.hide) {
          skip = true;
        }
      }

      if (!skip) {
        list.add(
          Column(
            key: ValueKey(store.currencies[index].symbol),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Slidable(
                startActionPane: !store.isReordering
                    ? ActionPane(
                        extentRatio: 0.2,
                        motion: const StretchMotion(),
                        children: [
                          Builder(
                            builder: (context) {
                              return CustomSlidableAction(
                                onPressed: (context) {
                                  store.onStartReordering();
                                },
                                backgroundColor: colors.purple,
                                foregroundColor: colors.white,
                                child: SStartReorderIcon(
                                  color: colors.white,
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : null,
                endActionPane: store.currencies[index].isAssetBalanceEmpty
                    ? ActionPane(
                        extentRatio: 0.2,
                        motion: const StretchMotion(),
                        children: [
                          CustomSlidableAction(
                            onPressed: (context) {
                              store.onDelete(index);
                            },
                            backgroundColor: colors.red,
                            foregroundColor: colors.white,
                            child: SDeleteAssetIcon(
                              color: colors.white,
                            ),
                          ),
                        ],
                      )
                    : null,
                child: MyWalletsAssetItem(
                  isMoving: store.isReordering,
                  currency: store.currencies[index],
                ),
              ),
              if (!store.isReordering &&
                  store.currencies[index].symbol == 'EUR' &&
                  store.buttonStatus != BankingShowState.hide)
                GetAccountButton(
                  store: store,
                ),
            ],
          ),
        );
      }
    }

    return list;
  }

  Widget _proxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    final colors = sKit.colors;

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.white,
              boxShadow: [
                BoxShadow(
                  color: colors.grey1.withOpacity(0.2),
                  blurRadius: 20,
                ),
              ],
            ),
            child: MyWalletsAssetItem(
              isMoving: true,
              currency: store.currencies[index],
            ),
          ),
        );
      },
      child: child,
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

class _OnlyOnePointerRecognizer extends OneSequenceGestureRecognizer {
  int _p = 0;

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);

    if (_p == 0) {
      resolve(GestureDisposition.rejected);
      _p = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'only one pointer recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _p) {
      _p = 0;
    }
  }
}
