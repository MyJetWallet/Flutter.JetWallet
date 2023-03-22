import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';
import 'simple_referral_stats_item.dart';

class SReferralStats extends StatelessWidget {
  const SReferralStats({
    Key? key,
    this.currencyPrefix,
    this.currencySymbol = '',
    required this.referralInvited,
    required this.referralActivated,
    required this.bonusEarned,
    required this.commissionEarned,
    required this.total,
    required this.showReadMore,
    required this.onInfoTap,
    required this.referralStatsText,
    required this.referralsInvitedText,
    required this.referralsActivatedText,
    required this.bonusEarnedText,
    required this.commissionEarnedText,
    required this.totalText,
  }) : super(key: key);

  final String? currencyPrefix;
  final String currencySymbol;
  final int referralInvited;
  final int referralActivated;
  final double bonusEarned;
  final double commissionEarned;
  final double total;
  final bool showReadMore;
  final void Function() onInfoTap;
  final String referralStatsText;
  final String referralsInvitedText;
  final String referralsActivatedText;
  final String bonusEarnedText;
  final String commissionEarnedText;
  final String totalText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 48,
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
              top: 30.0,
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
                    referralStatsText,
                    style: sTextH4Style,
                  ),
                ),
                if (showReadMore)
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: onInfoTap,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const SInfoPressedIcon(),
                    ),
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
                  text: referralsInvitedText,
                  baselineHeight: 46.0,
                  value: '$referralInvited',
                ),
                SReferralStatsItem(
                  text: referralsActivatedText,
                  value: '$referralInvited',
                ),
                SReferralStatsItem(
                  text: bonusEarnedText,
                  value: '${currencyPrefix ?? ''}$bonusEarned'
                      '${currencyPrefix == null ? ' $currencySymbol' : ''}',
                ),
                SReferralStatsItem(
                  text: commissionEarnedText,
                  value: '${currencyPrefix ?? ''}$commissionEarned'
                      '${currencyPrefix == null ? ' $currencySymbol' : ''}',
                ),
                const SpaceH40(),
                const SDivider(),
                SReferralStatsItem(
                  text: totalText,
                  value: '${currencyPrefix ?? ''}$total'
                      '${currencyPrefix == null ? ' $currencySymbol' : ''}',
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
