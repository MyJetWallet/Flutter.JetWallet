import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleIcons40X40Example extends StatelessWidget {
  const SimpleIcons40X40Example({Key? key}) : super(key: key);

  static const routeName = '/simple_icons_40x40_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: const [
              SConvertIcon(),
              SConvertPressedIcon(),
            ],
          ),
        ),
      ),
    );
  }
}
