import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';
import '../shared.dart';

class SimpleColorsExample extends ConsumerWidget {
  const SimpleColorsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_colors_example';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final sColors = watch(sColorPod);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ThemeSwitch(),
            const SpaceH20(),
            _ColorBox(
              color: sColors.black,
            ),
            _ColorBox(
              color: sColors.blue,
            ),
            _ColorBox(
              color: sColors.red,
            ),
            _ColorBox(
              color: sColors.green,
            ),
            _ColorBox(
              color: sColors.grey1,
            ),
            _ColorBox(
              color: sColors.grey2,
            ),
            _ColorBox(
              color: sColors.grey3,
            ),
            _ColorBox(
              color: sColors.grey4,
            ),
            _ColorBox(
              color: sColors.grey5,
            ),
            _ColorBox(
              color: sColors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  const _ColorBox({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.r,
      height: 50.r,
      margin: EdgeInsets.all(4.r),
      color: color,
    );
  }
}
