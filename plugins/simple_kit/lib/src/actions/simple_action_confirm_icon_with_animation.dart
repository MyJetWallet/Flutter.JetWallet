import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

import '../shared/constants.dart';

class SActionConfirmIconWithAnimation extends StatelessWidget {
  const SActionConfirmIconWithAnimation({
    Key? key,
    required this.iconUrl,
  }) : super(key: key);

  final String iconUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 160.r,
          height: 160.r,
          child: const RiveAnimation.asset(
            confirmActionAnimationAsset,
          ),
        ),
        SizedBox(
          width: 160.r,
          height: 160.r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.network(
                iconUrl,
                width: 48.r,
                height: 48.r,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
