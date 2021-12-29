import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../../src/colors/view/simple_colors_light.dart';

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
            SRewardBanner(
              color: SColorsLight().violet,
              primaryText: 'Invite friends\nand get \$10',
              secondaryText: 'Get a random coin with every trade over \$50',
            ),
            const SpaceH20(),
          ],
        ),
      ),
    );
  }
}
