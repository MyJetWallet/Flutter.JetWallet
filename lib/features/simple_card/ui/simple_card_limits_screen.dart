import 'package:auto_route/auto_route.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_limits_store.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'SimpleCardLimitsRouter')
class SimpleCardLimitsScreen extends StatelessWidget {
  const SimpleCardLimitsScreen({
    super.key,
    required this.cardLable,
    required this.cardId,
  });

  final String cardLable;
  final String cardId;

  @override
  Widget build(BuildContext context) {
    sAnalytics.spendingVirtualCardLimitsScreenView(cardID: cardId);
    
    return Provider(
      create: (context) => SimpleCardLimitsStore()..init(cardId),
      child: _SimpleCardLimitsScreenBody(
        cardLable: cardLable,
      ),
    );
  }
}

class _SimpleCardLimitsScreenBody extends StatelessWidget {
  const _SimpleCardLimitsScreenBody({
    required this.cardLable,
  });

  final String cardLable;

  @override
  Widget build(BuildContext context) {
    final store = SimpleCardLimitsStore.of(context);
    final colors = SColorsLight();

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: GlobalBasicAppBar(
        title: intl.simple_card_spending_limits,
        subtitle: cardLable,
        hasRightIcon: false,
      ),
      child: SPaddingH24(
        child: Observer(
          builder: (context) {
            return CustomRefreshIndicator(
              notificationPredicate: (_) => true,
              offsetToArmed: 75,
              onRefresh: store.refreshData,
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
                                color: colors.gray2,
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SpaceH16(),
                        LimitsButton(
                          isLoading: store.isLoading,
                          title: intl.simple_card_limits_daily_limits,
                          subtitle: store.dailyLimitsData,
                          indicationTitle1: intl.simple_card_limits_monthly_spending,
                          indicationValue1: store.dailySpendingValue,
                          indicationLable1: store.dailySpendingLimit,
                          progress1: store.dailySpendingProgress,
                          indicationTitle2: intl.simple_card_limits_monthly_atm_withdrawals,
                          indicationValue2: store.dailyWithdrawalValue,
                          indicationLable2: store.dailyWithdrawalLimit,
                          progress2: store.dailyWithdrawalProgress,
                        ),
                        const SpaceH16(),
                        LimitsButton(
                          isLoading: store.isLoading,
                          title: intl.simple_card_limits_monthly_limits,
                          subtitle: store.monthlyLimitsData,
                          indicationTitle1: intl.simple_card_limits_monthly_spending,
                          indicationValue1: store.monthlySpendingValue,
                          indicationLable1: store.monthlySpendingLimit,
                          progress1: store.monthlySpendingProgress,
                          indicationTitle2: intl.simple_card_limits_monthly_atm_withdrawals,
                          indicationValue2: store.monthlyWithdrawalValue,
                          indicationLable2: store.monthlyWithdrawalLimit,
                          progress2: store.monthlyWithdrawalProgress,
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
    );
  }
}
