import 'dart:async';

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
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/earn/widgets/earn_dashboard_section_widget.dart';
import 'package:jetwallet/features/market/market_details/store/market_news_store.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/my_wallets/widgets/actions_my_wallets_row_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/add_wallet_bottom_sheet.dart';
import 'package:jetwallet/features/my_wallets/widgets/banners_carusel.dart';
import 'package:jetwallet/features/my_wallets/widgets/change_order_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/my_wallets_asset_item.dart';
import 'package:jetwallet/features/my_wallets/widgets/news_dashboard_section.dart';
import 'package:jetwallet/features/my_wallets/widgets/pending_transactions_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/top_movers_dashboard_section.dart';
import 'package:jetwallet/features/my_wallets/widgets/user_avatar_widget.dart';
import 'package:jetwallet/features/simple_coin/widgets/simple_coin_asset_item.dart';
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
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../core/services/user_info/user_info_service.dart';
import '../../../utils/helpers/check_kyc_status.dart';
import '../../kyc/kyc_service.dart';
import '../../simple_card/store/simple_card_store.dart';

@RoutePage(name: 'MyWalletsRouter')
class MyWalletsScreen extends StatefulWidget {
  const MyWalletsScreen({super.key});

  @override
  State<MyWalletsScreen> createState() => _MyWalletsScreenState();
}

class _MyWalletsScreenState extends State<MyWalletsScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MyWalletsSrore>(create: (context) => MyWalletsSrore()),
        Provider<MarketNewsStore>(create: (context) => MarketNewsStore()..loadNews('')),
      ],
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

    _controller.addListener(() {
      if (_controller.offset >= _controller.position.maxScrollExtent) {
        final newsStore = MarketNewsStore.of(context);
        newsStore.loadMoreNews();
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
    getIt.get<EventBus>().fire(EndReordering());

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
    myWalletsSrore.endReorderingImmediately();

    sRouter.push(const AccountRouter());
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

    store = MyWalletsSrore.of(context) as MyWalletsSrore;

    final list = slidableItems(store);

    return VisibilityDetector(
      key: const Key('my_vallets-screen-key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          sAnalytics.walletsScreenView(
            favouritesAssetsList: List.generate(
              store.currencies.length,
              (index) => store.currencies[index].symbol,
            ),
          );
        }
      },
      child: RawGestureDetector(
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
                CollapsedMainscreenAppbar(
                  scrollController: _controller,
                  mainHeaderValue: !getIt<AppStore>().isBalanceHide
                      ? _price(
                          currenciesWithBalanceFrom(
                            sSignalRModules.currenciesList,
                          ),
                          sSignalRModules.baseCurrency,
                        )
                      : '**** ${sSignalRModules.baseCurrency.symbol}',
                  mainHeaderTitle: intl.home_header_total_balance,
                  mainHeaderCollapsedTitle: intl.home_header_simple,
                  isLabelIconShow: getIt<AppStore>().isBalanceHide,
                  onLabelIconTap: () {
                    _onLabelIconTap();
                  },
                  onProfileTap: () {
                    _headerTap();
                  },
                  onOnChatTap: () async {
                    getIt.get<EventBus>().fire(EndReordering());

                    if (showZendesk) {
                      await getIt.get<IntercomService>().showMessenger();
                    } else {
                      await sRouter.push(
                        CrispRouter(
                          welcomeText: intl.crispSendMessage_hi,
                        ),
                      );
                    }
                  },
                  isLoading: store.isLoading,
                  userAvatar: const UserAvatarWidget(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: ActionsMyWalletsRowWidget(),
                  ),
                ),
                Expanded(
                  child: CustomRefreshIndicator(
                    notificationPredicate: !store.isReordering ? (_) => true : (_) => false,
                    offsetToArmed: 75,
                    onRefresh: () async {
                      await getIt.get<SignalRService>().forceReconnectSignalR();
                      await MarketNewsStore.of(context).loadNews('');
                    },
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
                              physics: const AlwaysScrollableScrollPhysics().applyTo(const ClampingScrollPhysics()),
                              slivers: [
                                const SliverToBoxAdapter(
                                  child: BannerCarusel(),
                                ),
                                if (store.countOfPendingTransactions > 0) ...[
                                  SliverToBoxAdapter(
                                    child: PendingTransactionsWidget(
                                      countOfTransactions: store.countOfPendingTransactions,
                                      onTap: () {
                                        sAnalytics.tapOnTheButtonPendingTransactionsOnWalletsScreen(
                                          numberOfPendingTrx: store.countOfPendingTransactions,
                                        );

                                        store.endReorderingImmediately();

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
                                      },
                                    ),
                                  ),
                                ],
                                if (store.isReordering)
                                  SliverToBoxAdapter(
                                    child: ChangeOrderWidget(
                                      onPressedDone: () {
                                        store.onEndReordering();
                                        goTop();
                                      },
                                    ),
                                  ),
                                SliverToBoxAdapter(
                                  child: STableHeader(
                                    size: SHeaderSize.m,
                                    title: intl.my_wallets_header,
                                  ),
                                ),
                                const SliverToBoxAdapter(
                                  child: SimpleCoinAssetItem(),
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
                                if (store.currenciesForSearch.isNotEmpty && !store.isReordering)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 16,
                                        bottom: 32,
                                      ),
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
                                  ),
                                const SliverToBoxAdapter(
                                  child: EarnDashboardSectionWidget(),
                                ),
                                const SliverToBoxAdapter(
                                  child: TopMoversDashboardSection(),
                                ),
                                const SliverToBoxAdapter(
                                  child: NewsDashboardSection(),
                                ),
                                const SliverToBoxAdapter(
                                  child: SizedBox(height: 24),
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
