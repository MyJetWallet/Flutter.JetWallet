import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../referral_stats/notifier/campaign_and_referral_notipod.dart';
import '../helper/create_reward_banner.dart';

class Rewards extends HookWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    final campaignAndReferral = useProvider(campaignAndReferralNotipod);
    final rng = Random();

    return SPageFrameWithPadding(
      header: const SSmallHeader(
        title: 'Rewards',
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                for (final item in campaignAndReferral.campaigns) ...[
                    createRewardBanner(item, rng, colors),
                ],
                for (final item in campaignAndReferral.referralStats) ...[
                  const SpaceH20(),
                  SReferralStats(
                    referralInvited: item.referralInvited,
                    referralActivated: item.referralActivated,
                    bonusEarned: item.bonusEarned,
                    commissionEarned: item.commissionEarned,
                    total: item.total,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
