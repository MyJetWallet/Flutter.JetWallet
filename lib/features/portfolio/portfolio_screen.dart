import 'package:auto_route/auto_route.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_header.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/components/actions_portfolio_row_widget.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/components/assets_list_widget.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/components/balance_amount_widget.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../utils/helpers/currencies_helpers.dart';

@RoutePage(name: 'PortfolioRouter')
class PortfolioScreen extends StatefulObserverWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {


  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final currencies = sSignalRModules.currenciesList;
    final currenciesList = currencies.toList();
    sortCurrenciesMyAssets(currenciesList);

    return SPageFrame(
      color: colors.white,
      loaderText: '',
      header: const Column(
        children: [
          SpaceH54(),
          PortfolioHeader(),
          SpaceH15(),
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
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            BalanceAmountWidget(),
            SpaceH40(),
            ActionsPortfolioRowWidget(),
            SpaceH30(),
            AssetsListWidget(),
          ],
        ),
      ),
    );
  }
}
