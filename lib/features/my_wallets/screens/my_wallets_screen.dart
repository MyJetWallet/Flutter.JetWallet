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
import 'package:jetwallet/features/my_wallets/widgets/my_wallets_header.dart';
import 'package:jetwallet/features/my_wallets/widgets/pending_transactions_widget.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:rive/rive.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

  @override
  void initState() {
    super.initState();

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
      header: Column(
        children: [
          const SpaceH54(),
          VisibilityDetector(
            key: const Key('header'),
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction != 0) {
                sAnalytics.walletsScreenView(
                  favouritesAssetsList: List.generate(
                    store.currencies.length,
                    (index) => store.currencies[index].symbol,
                  ),
                );
              }
            },
            child: MyWalletsHeader(
              isTitleCenter: !isTopPosition,
            ),
          ),
        ],
      ),
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
          child: ListView(
            controller: _controller,
            padding: EdgeInsets.zero,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const BalanceAmountWidget(),
              const SpaceH32(),
              const ActionsMyWalletsRowWidget(),
              const SpaceH28(),
              if (store.countOfPendingTransactions > 0) ...[
                PendingTransactionsWidget(
                  countOfTransactions: store.countOfPendingTransactions,
                  onTap: () {
                    sAnalytics.tapOnTheButtonPendingTransactionsOnWalletsScreen(
                      numberOfPendingTrx: store.countOfPendingTransactions,
                    );
                    if (store.isReordering) {
                      store.endReorderingImmediately();
                    } else {
                      sRouter.push(
                        TransactionHistoryRouter(
                          initialIndex: 1,
                        ),
                      );
                    }
                  },
                ),
                const SpaceH10(),
              ],
              const AssetsListWidget(),
              const SpaceH16(),
              if (store.currenciesForSearch.isNotEmpty && !store.isReordering)
                Row(
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
              const SpaceH31(),
            ],
          ),
        ),
      ),
    );
  }
}
