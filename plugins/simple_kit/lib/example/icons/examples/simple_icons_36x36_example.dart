import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleIcons36X36Example extends StatelessWidget {
  const SimpleIcons36X36Example({Key? key}) : super(key: key);

  static const routeName = '/simple_icons_36x36_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30.0),
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
