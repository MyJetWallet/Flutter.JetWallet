import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimpleIcons56X56Example extends StatelessWidget {
  const SimpleIcons56X56Example({Key? key}) : super(key: key);

  static const routeName = '/simple_icons_56x56_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30.w),
          child: GridView.count(
            crossAxisCount: 2,
            children: const [
              SActionActiveIcon(),
              SActionDefaultIcon(),
              SMarketActiveIcon(),
              SMarketDefaultIcon(),
              SNewsActiveIcon(),
              SNewsDefaultIcon(),
              SPortfolioActiveIcon(),
              SPortfolioDefaultIcon(),
              SProfileActiveIcon(),
              SProfileDefailtIcon(),
            ],
          ),
        ),
      ),
    );
  }
}
