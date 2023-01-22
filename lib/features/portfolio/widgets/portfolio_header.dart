import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/chart/model/chart_union.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/referral_program_gift/service/referral_gift_service.dart';
import 'package:jetwallet/features/rewards/model/campaign_or_referral_model.dart';
import 'package:jetwallet/features/rewards/store/reward_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../utils/formatting/base/base_currencies_format.dart';
import '../../../utils/models/base_currency_model/base_currency_model.dart';

class PortfolioHeader extends StatelessObserverWidget {
  const PortfolioHeader({
    Key? key,
    this.emptyBalance = false,
    this.price = '',
    this.showPrice = false,
  }) : super(key: key);

  final bool emptyBalance;
  final bool showPrice;
  final String price;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final gift = referralGift();
    final state = RewardStore();
    final baseCurrency = sSignalRModules.baseCurrency;
    //final chart = ChartStore(balanceChartInput());

    ChartStore? chart;

    if (!emptyBalance) {
      chart = ChartStore.of(context) as ChartStore;
    }

    Color getContainerColor() {
      return (chart != null && chart.union != const ChartUnion.loading()) ||
              emptyBalance
          ? Colors.transparent
          : colors.grey5;
    }

    return Container(
      height: 120,
      color: getContainerColor(),
      child: Column(
        children: [
          const SpaceH64(),
          Row(
            children: [
              const SpaceW24(),
              Text(
                '${intl.portfolioHeader_balance}${showPrice ? ': $price' : ''}',
                style: sTextH5Style,
              ),
              const Spacer(),
              SIconButton(
                defaultIcon: SNotificationsIcon(
                  color: colors.black,
                ),
                pressedIcon: SNotificationsIcon(
                  color: colors.black.withOpacity(0.7),
                ),
                onTap: () {
                  sAnalytics.rewardsScreenView(Source.giftIcon);

                  sRouter.push(const RewardsRouter());
                },
              ),
              const SpaceW34(),
              SIconButton(
                defaultIcon: SProfileDetailsIcon(
                  color: colors.black,
                ),
                pressedIcon: SProfileDetailsIcon(
                  color: colors.black.withOpacity(0.7),
                ),
                onTap: () {
                  sRouter.push(const AccountRouter());
                },
              ),
              const SpaceW26(),
            ],
          ),
        ],
      ),
    );
  }
}
