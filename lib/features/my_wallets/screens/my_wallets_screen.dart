import 'dart:async';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:decimal/decimal.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/models/kyc_verified_model.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/my_wallets/widgets/actions_my_wallets_row_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/add_wallet_bottom_sheet.dart';
import 'package:jetwallet/features/my_wallets/widgets/change_order_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/my_wallets_asset_item.dart';
import 'package:jetwallet/features/my_wallets/widgets/pending_transactions_widget.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/delete_asset/simple_delete_asset.dart';
import 'package:simple_kit/modules/icons/24x24/public/start_reorder/simple_start_reorder_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/shared/simple_skeleton_loader.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:timezone/data/latest.dart';

import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../core/services/user_info/user_info_service.dart';
import '../../../utils/helpers/check_kyc_status.dart';
import '../../kyc/kyc_service.dart';
import '../../simple_card/store/simple_card_store.dart';
import '../../simple_card/ui/widgets/get_card_banner.dart';

@RoutePage(name: 'MyWalletsRouter')
class MyWalletsScreen extends StatefulWidget {
  const MyWalletsScreen({super.key});

  @override
  State<MyWalletsScreen> createState() => _MyWalletsScreenState();
}

class _MyWalletsScreenState extends State<MyWalletsScreen> {
  @override
  Widget build(BuildContext context) {
    return Provider<MyWalletsSrore>(
      create: (context) => MyWalletsSrore(),
      builder: (context, child) => const _MyWalletsScreenBody(),
    );
  }
}

class _MyWalletsScreenBody extends StatefulObserverWidget {
  const _MyWalletsScreenBody();

  @override
  State<_MyWalletsScreenBody> createState() => __MyWalletsScreenBodyState();
}

class __MyWalletsScreenBodyState extends State<_MyWalletsScreenBody> {
  final _controller = ScrollController();
  bool isTopPosition = true;

  // for analytic
  GlobalHistoryTab historyTab = GlobalHistoryTab.pending;

  @override
  void initState() {
    super.initState();
    final simpleCardStore = getIt.get<SimpleCardStore>();

    initializeTimeZones();

    simpleCardStore.checkCardBanner();

    Timer(
      const Duration(seconds: 2),
      () {
        final userInfo = getIt.get<UserInfoService>();
        final kycState = getIt.get<KycService>();

        if (userInfo.isSimpleCardAvailable &&
            (sSignalRModules.bankingProfileData?.banking?.cards?.length ?? 0) < 1 &&
            !simpleCardStore.wasCardBannerClosed &&
            checkKycPassed(
              kycState.depositStatus,
              kycState.tradeStatus,
              kycState.withdrawalStatus,
            )) {
          sAnalytics.viewGetSimpleCard();
        }
      },
    );

    // sAnalytics.walletsScreenView(
    //   favouritesAssetsList: List.generate(
    //     store.currencies.length,
    //     (index) => store.currencies[index].symbol,
    //   ),
    // );

    _controller.addListener(() {
      if (_controller.position.pixels <= 265) {
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

    getIt<EventBus>().on<EndReordering>().listen((event) {
      store.endReorderingImmediately();
    });
  }

  void _onLabelIconTap() {
    if (getIt<AppStore>().isBalanceHide) {
      getIt<AppStore>().setIsBalanceHide(false);
    } else {
      getIt<AppStore>().setIsBalanceHide(true);
    }
    sAnalytics.tapOnTheButtonShowHideBalancesOnWalletsScreen(
      isShowNow: !getIt<AppStore>().isBalanceHide,
    );
  }

  void _headerTap() {
    sAnalytics.tapOnTheButtonProfileOnWalletsScreen();
    final myWalletsSrore = MyWalletsSrore.of(context);
    if (myWalletsSrore.isReordering) {
      myWalletsSrore.endReorderingImmediately();
    } else {
      sRouter.push(const AccountRouter());
    }
  }

  Future<void> goTop() async {
    await Future.delayed(const Duration(milliseconds: 110), () {
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  late MyWalletsSrore store;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final userInfo = getIt.get<UserInfoService>();
    final kycState = getIt.get<KycService>();
    final simpleCardStore = getIt.get<SimpleCardStore>();

    store = MyWalletsSrore.of(context) as MyWalletsSrore;

    final list = slidableItems(store);

    final notificationsCount = _profileNotificationLength(
      KycModel(
        depositStatus: kycState.depositStatus,
        sellStatus: kycState.tradeStatus,
        withdrawalStatus: kycState.withdrawalStatus,
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
        verificationInProgress: kycState.verificationInProgress,
      ),
      true,
    );

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
          loaderText: intl.loader_please_wait,
          loading: store.loader,
          child: Column(
            children: [
              if (!store.isReordering)
                CollapsedMainscreenAppbar(
                  scrollController: _controller,
                  mainHeaderValue: !getIt<AppStore>().isBalanceHide
                      ? _price(
                          currenciesWithBalanceFrom(sSignalRModules.currenciesList),
                          sSignalRModules.baseCurrency,
                        )
                      : '**** ${sSignalRModules.baseCurrency.symbol}',
                  mainHeaderTitle: intl.my_wallets_header,
                  mainHeaderCollapsedTitle: intl.my_wallets_header,
                  isLabelIconShow: getIt<AppStore>().isBalanceHide,
                  onLabelIconTap: () {
                    _onLabelIconTap();
                  },
                  onProfileTap: () {
                    _headerTap();
                  },
                  profileNotificationsCount: notificationsCount,
                  isLoading: store.isLoading,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: ActionsMyWalletsRowWidget(),
                  ),
                ),
              Expanded(
                child: CustomRefreshIndicator(
                  notificationPredicate: !store.isReordering ? (_) => true : (_) => false,
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
                                  child: const rive.RiveAnimation.asset(
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
                    child: store.isLoading
                        ? const _LoadingAssetsList()
                        : CustomScrollView(
                            controller: _controller,
                            physics: store.isReordering
                                ? const ClampingScrollPhysics()
                                : const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              if (store.isReordering)
                                SliverToBoxAdapter(
                                  child: MainScreenAppbar(
                                    headerTitle: intl.my_wallets_header,
                                    headerValue: !getIt<AppStore>().isBalanceHide
                                        ? _price(
                                            currenciesWithBalanceFrom(sSignalRModules.currenciesList),
                                            sSignalRModules.baseCurrency,
                                          )
                                        : '**** ${sSignalRModules.baseCurrency.symbol}',
                                    onLabelIconTap: () {
                                      _onLabelIconTap();
                                    },
                                    onProfileTap: () {
                                      _headerTap();
                                    },
                                    isLabelIconShow: getIt<AppStore>().isBalanceHide,
                                    profileNotificationsCount: notificationsCount,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 24),
                                      child: ActionsMyWalletsRowWidget(),
                                    ),
                                  ),
                                ),
                              if (userInfo.isSimpleCardAvailable &&
                                  (sSignalRModules.bankingProfileData?.banking?.cards?.length ?? 0) < 1 &&
                                  !simpleCardStore.wasCardBannerClosed &&
                                  checkKycPassed(
                                    kycState.depositStatus,
                                    kycState.tradeStatus,
                                    kycState.withdrawalStatus,
                                  ))
                                const SliverToBoxAdapter(
                                  child: GetCardBanner(),
                                ),
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
                                              final result =
                                                  index == 0 ? GlobalHistoryTab.all : GlobalHistoryTab.pending;
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
                                    minHeight: isTopPosition ? 64 : 117,
                                    maxHeight: isTopPosition ? 64 : 117,
                                    child: ChangeOrderWidget(
                                      isTopPosition: isTopPosition,
                                      onPressedDone: () {
                                        store.onEndReordering();
                                        goTop();
                                      },
                                    ),
                                  ),
                                ),
                              SliverReorderableList(
                                proxyDecorator: (child, index, animation) {
                                  return _proxyDecorator(
                                    child: child,
                                    index: index,
                                    animation: animation,
                                    store: store,
                                  );
                                },
                                onReorder: (int oldIndex, int newIndex) {
                                  store.onReorder(oldIndex, newIndex);

                                  setState(() {});
                                },
                                //itemCount: list.length,
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
                                  child: SPaddingH24(
                                    child: Row(
                                      children: [
                                        SButtonContext(
                                          type: SButtonContextType.iconedSmall,
                                          text: intl.my_wallets_add_wallet,
                                          onTap: () {
                                            sAnalytics.tapOnTheButtonAddWalletOnWalletsScreen();
                                            showAddWalletBottomSheet(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              SliverToBoxAdapter(
                                child: list.length < 6 ? const SizedBox(height: 160) : const SpaceH76(),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> slidableItems(MyWalletsSrore store) {
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
                endActionPane: store.currencies[index].isAssetBalanceEmpty && store.currencies[index].symbol != 'EUR'
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
                  store: store,
                ),
              ),
            ],
          ),
        );
      }
    }

    return list;
  }

  Widget _proxyDecorator({
    required Widget child,
    required int index,
    required Animation<double> animation,
    required MyWalletsSrore store,
  }) {
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
              store: store,
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

String _price(
  List<CurrencyModel> items,
  BaseCurrencyModel baseCurrency,
) {
  var totalBalance = Decimal.zero;

  for (final item in items) {
    totalBalance += item.baseBalance;
  }

  return volumeFormat(
    decimal: totalBalance,
    accuracy: baseCurrency.accuracy,
    symbol: baseCurrency.symbol,
  );
}

int _profileNotificationLength(KycModel kycState, bool twoFaEnable) {
  var notificationLength = 0;

  final passed = checkKycPassed(
    kycState.depositStatus,
    kycState.sellStatus,
    kycState.withdrawalStatus,
  );

  if (!passed) {
    notificationLength += 1;
  }

  if (!twoFaEnable) {
    notificationLength += 1;
  }

  return notificationLength;
}

class _LoadingAssetsList extends StatelessWidget {
  const _LoadingAssetsList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _LoadingAssetItem(),
        _LoadingAssetItem(),
        _LoadingAssetItem(),
      ],
    );
  }
}

class _LoadingAssetItem extends StatelessWidget {
  const _LoadingAssetItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SSkeletonLoader(
              height: 24,
              width: 24,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SpaceW12(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SSkeletonLoader(
                height: 24,
                width: 64,
                borderRadius: BorderRadius.circular(4),
              ),
              const SpaceH8(),
              SSkeletonLoader(
                height: 16,
                width: 120,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          const Spacer(),
          SSkeletonLoader(
            width: 96,
            height: 44,
            borderRadius: BorderRadius.circular(22),
          ),
        ],
      ),
    );
  }
}
