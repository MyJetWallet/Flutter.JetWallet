import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../../src/banners/rewards_banner/simple_three_steps_reward_banner.dart';

class SimpleRewardsBannerExample extends StatelessWidget {
  const SimpleRewardsBannerExample({
    Key? key,
  }) : super(key: key);

  static const routeName = '/simple_rewards_banner_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SPaddingH24(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SRewardBannerExample(
              bannerColor: SColorsLight().violet,
              primaryText: 'Invite friends\nand get \$10',
              secondaryText: 'Get a rando m coin with every trade over \$50',
            ),
            const SpaceH20(),
            const SThreeStepsRewardBanner(
              primaryText: 'Complete 3 steps to receive \$30',
              timeToComplete: '',
            ),
          ],
        ),
      ),
    );
  }
}
