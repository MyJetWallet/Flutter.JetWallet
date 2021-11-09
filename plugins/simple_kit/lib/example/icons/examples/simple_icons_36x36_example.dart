import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimpleIcons36X36Example extends StatelessWidget {
  const SimpleIcons36X36Example({Key? key}) : super(key: key);

  static const routeName = '/simple_icons_36x36_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30.w),
          child: GridView.count(
            crossAxisCount: 2,
            children: const [
              SFaceIdIcon(),
              SFaceIdPressedIcon(),
              SFingerprintIcon(),
              SFingerprintPressedIcon(),
              SKeyboardEraseIcon(),
              SKeyboardErasePressedIcon(),
            ],
          ),
        ),
      ),
    );
  }
}
