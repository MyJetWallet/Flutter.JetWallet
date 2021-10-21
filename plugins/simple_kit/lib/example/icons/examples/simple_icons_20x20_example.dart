import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimpleIcons20X20Example extends StatelessWidget {
  const SimpleIcons20X20Example({Key? key}) : super(key: key);

  static const routeName = '/simple_icons_20x20_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30.w),
          child: GridView.count(
            crossAxisCount: 2,
            children: const [
              SActionBuyIcon(),
              SActionConvertIcon(),
              SActionDepositIcon(),
              SActionReceiveIcon(),
              SActionSellIcon(),
              SActionSendIcon(),
              SActionWithdrawIcon(),
            ],
          ),
        ),
      ),
    );
  }
}
