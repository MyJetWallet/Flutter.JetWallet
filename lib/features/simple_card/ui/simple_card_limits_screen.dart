import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_limits_store.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'SimpleCardLimitsRouter')
class SimpleCardLimitsScreen extends StatelessWidget {
  const SimpleCardLimitsScreen({
    super.key,
    required this.cardLable,
    required this.cardId,
    this.isVirtual = true,
  });

  final String cardLable;
  final String cardId;
  final bool isVirtual;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => SimpleCardLimitsStore()..init(cardId),
      child: _SimpleCardLimitsScreenBody(
        cardLable: cardLable,
        isVirtual: isVirtual,
      ),
    );
  }
}

class _SimpleCardLimitsScreenBody extends StatelessWidget {
  const _SimpleCardLimitsScreenBody({
    required this.cardLable,
    this.isVirtual = true,
  });

  final String cardLable;
  final bool isVirtual;

  @override
  Widget build(BuildContext context) {
    final store = SimpleCardLimitsStore.of(context);

    return SPageFrameWithPadding(
      loaderText: intl.loader_please_wait,
      header: GlobalBasicAppBar(
        title: intl.simple_card_spending_limits,
        subtitle: cardLable,
        hasRightIcon: false,
      ),
      child: Observer(
        builder: (context) {
          return Column(
            children: [
              const SpaceH16(),
              LimitsButton(
                isLoading: store.isLoading,
                hasSecondItem: !isVirtual,
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
                hasSecondItem: !isVirtual,
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
          );
        },
      ),
    );
  }
}
