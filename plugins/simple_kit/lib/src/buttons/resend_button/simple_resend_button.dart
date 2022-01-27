import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SResendButton extends StatelessWidget {
  const SResendButton({
    Key? key,
    this.active = true,
    required this.onTap,
    required this.timer,
  }) : super(key: key);

  final bool active;
  final Function() onTap;
  final int timer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            timer != 0
                ? 'You can resend in $timer seconds'
                : "Didn't receive the code?",
            style: sCaptionTextStyle.copyWith(
              color: SColorsLight().grey2,
            ),
          ),
        ),
        const SpaceH10(),
        Visibility(
          visible: timer == 0,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: STextButton1(
            active: active,
            name: 'Resend',
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
