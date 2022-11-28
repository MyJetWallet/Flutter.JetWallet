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
              GestureDetector(
                onTap: () {
                  sAnalytics.rewardsScreenView(Source.giftIcon);

                  sRouter.push(const RewardsRouter());
                },
                child: Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: colors.green,
                  ),
                  child: Row(
                    children: [
                      const SGiftPortfolioIcon(),
                      if (gift == ReferralGiftStatus.showGift) ...[
                        Container(
                          margin: (_giftBonus(
                            state.sortedCampaigns,
                            baseCurrency,
                          ).isNotEmpty)
                              ? const EdgeInsets.only(right: 8)
                              : EdgeInsets.zero,
                          child: Text(
                            _giftBonus(state.sortedCampaigns, baseCurrency),
                            style: sSubtitle3Style.copyWith(
                              color: colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SpaceW24(),
            ],
          ),
        ],
      ),
    );
  }

  String _giftBonus(
    List<CampaignOrReferralModel> rewards,
    BaseCurrencyModel baseCurrency,
  ) {
    var bonusGift = Decimal.zero;

    for (final item in rewards) {
      if (item.campaign?.conditions?.isNotEmpty ?? false) {
        for (final condition in item.campaign!.conditions!) {
          if (condition.reward != null) {
            bonusGift = bonusGift + condition.reward!.amount;
          }
        }
      }
    }

    return bonusGift == Decimal.zero
        ? ''
        : baseCurrenciesFormat(
            prefix: baseCurrency.prefix ?? '',
            text: '$bonusGift',
            symbol: baseCurrency.symbol,
          );
  }
}
