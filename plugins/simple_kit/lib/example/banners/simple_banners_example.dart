import 'package:flutter/material.dart';
import '../shared.dart';
import 'rewards_banner/simple_rewards_banner_example.dart';

class SimpleBannersExample extends StatelessWidget {
  const SimpleBannersExample({Key? key}) : super(key: key);

  static const routeName = '/simple_banners_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          NavigationButton(
            buttonName: 'rewards banner',
            routeName: SimpleRewardsBannerExample.routeName,
          ),
        ],
      ),
    );
  }
}
