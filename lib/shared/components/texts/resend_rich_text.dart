import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

class ResendRichText extends HookWidget {
  const ResendRichText({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "Didn't receive the code",
            style: sCaptionTextStyle.copyWith(
              color: SColorsLight().grey2,
            ),
          ),
          const SpaceH10(),
          STextButton1(
            active: true,
            name: 'Resend',
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
