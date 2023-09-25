import 'package:auto_route/auto_route.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/my_wallets/widgets/actions_my_wallets_row_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/assets_list_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/balance_amount_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/my_wallets_header.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../utils/helpers/currencies_helpers.dart';

@RoutePage(name: 'MyWalletsRouter')
class MyWalletsScreen extends StatefulObserverWidget {
  const MyWalletsScreen({super.key});

  @override
  State<MyWalletsScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<MyWalletsScreen> {
  final _controller = ScrollController();
  bool isTopPosition = true;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (isTopPosition != (_controller.position.pixels == 0)) {
        if (_controller.position.pixels < 0) {
          setState(() {
            isTopPosition = true;
          });
        } else {
          setState(() {
            isTopPosition = _controller.position.pixels == 0;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final currencies = sSignalRModules.currenciesList;
    final currenciesList = currencies.toList();
    sortCurrenciesMyAssets(currenciesList);

    return SPageFrame(
      color: colors.white,
      loaderText: '',
      header: Column(
        children: [
          const SpaceH54(),
          MyWalletsHeader(
            isTitleCenter: !isTopPosition,
          ),
          const SpaceH15(),
        ],
      ),
      child: CustomRefreshIndicator(
        offsetToArmed: 200,
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
                      height: 75,
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
                    offset: Offset(0.0, controller.value * 50),
                    child: child,
                  );
                },
                animation: controller,
              ),
            ],
          );
        },
        child: ListView(
          controller: _controller,
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            BalanceAmountWidget(),
            SpaceH40(),
            ActionsMyWalletsRowWidget(),
            SpaceH30(),
            AssetsListWidget(),
          ],
        ),
      ),
    );
  }
}
