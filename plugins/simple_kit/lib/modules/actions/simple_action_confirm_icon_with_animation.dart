import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/utils/constants.dart';

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
        const SizedBox(
          width: 160.0,
          height: 160.0,
          child: RiveAnimation.asset(
            confirmActionAnimationAsset,
          ),
        ),
        SizedBox(
          width: 160.0,
          height: 160.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.network(
                iconUrl,
                width: 48.0,
                height: 48.0,
                //color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
