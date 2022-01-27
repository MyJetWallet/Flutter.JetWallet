import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleIcons16X16Example extends StatelessWidget {
  const SimpleIcons16X16Example({Key? key}) : super(key: key);

  static const routeName = '/simple_icons_16x16_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: const [
              SSmallArrowPositiveIcon(),
              SSmallArrowNegativeIcon(),
              STickIcon(),
              STickSelectedIcon(),
              SSmileBadIcon(),
              SSmileGoodIcon(),
              SSmileNeutralIcon(),
              SCrossIcon(),
              SFeeAlertIcon(),
            ],
          ),
        ),
      ),
    );
  }
}
