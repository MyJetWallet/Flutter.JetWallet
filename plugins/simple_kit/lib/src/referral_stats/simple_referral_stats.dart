import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';
import 'simple_referral_stats_item.dart';

class SReferralStats extends StatelessWidget {
  const SReferralStats({
    Key? key,
    required this.referralInvited,
    required this.referralActivated,
    required this.bonusEarned,
    required this.commissionEarned,
    required this.total,
    required this.onInfoTap,
  }) : super(key: key);

  final int referralInvited;
  final int referralActivated;
  final double bonusEarned;
  final double commissionEarned;
  final double total;
  final void Function() onInfoTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          width: 3.0,
          color: SColorsLight().grey4,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 17.0,
              right: 17.0,
              top: 21.0,
              bottom: 24.0,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: SColorsLight().grey4,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Baseline(
                  baseline: 20.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    'Referral Stats',
                    style: sTextH4Style,
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: onInfoTap,
                  child: const SInfoPressedIcon(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Column(
              children: [
                SReferralStatsItem(
                  text: 'Referrals invited',
                  baselineHeight: 46.0,
                  value: '$referralInvited',
                ),
                SReferralStatsItem(
                  text: 'Referral activated',
                  value: '$referralInvited',
                ),
                SReferralStatsItem(
                  text: 'Bonus earned',
                  value: '\$$bonusEarned',
                ),
                SReferralStatsItem(
                  text: 'Commission earned',
                  value: '\$$commissionEarned',
                ),
                const SpaceH40(),
                const SDivider(),
                SReferralStatsItem(
                  text: 'Total',
                  value: '\$$total',
                  valueColor: SColorsLight().green,
                ),
                const SpaceH30(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
