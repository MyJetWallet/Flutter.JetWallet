import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleIcons56X56Example extends StatelessWidget {
  const SimpleIcons56X56Example({Key? key}) : super(key: key);

  static const routeName = '/simple_icons_56x56_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: const [
              SActionActiveIcon(),
              SActionDefaultIcon(),
              SMarketActiveIcon(),
              SMarketDefaultIcon(),
              SNewsActiveIcon(),
              SNewsDefaultIcon(),
              SEarnActiveIcon(),
              SEarnDefaultIcon(),
              SPortfolioActiveIcon(),
              SPortfolioDefaultIcon(),
              SProfileActiveIcon(),
              SProfileDefaultIcon(),
            ],
          ),
        ),
      ),
    );
  }
}
