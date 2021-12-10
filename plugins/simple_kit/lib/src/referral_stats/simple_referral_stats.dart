import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';
import 'simple_referral_stats_item.dart';

class SReferralStats extends StatelessWidget {
  const SReferralStats({
    Key? key,
    required this.referralInvited,
    required this.referralActivated,
    required this.bonusEarned,
    required this.commissionEarned,
    required this.total,
  }) : super(key: key);

  final int referralInvited;
  final int referralActivated;
  final double bonusEarned;
  final double commissionEarned;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327.w,
      padding: EdgeInsets.only(
        left: 17.w,
        right: 17.w,
        top: 21.w,
        bottom: 27.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          width: 3.w,
          color: SColorsLight().grey4,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Baseline(
                baseline: 20,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  'ReferralStats',
                  style: sTextH4Style,
                ),
              ),
              const SInfoPressedIcon(),
            ],
          ),
          const SpaceH24(),
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
        ],
      ),
    );
  }
}
