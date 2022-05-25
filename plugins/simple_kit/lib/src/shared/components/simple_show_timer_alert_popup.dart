import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

void sShowTimerAlertPopup({
  required BuildContext context,
  required String description,
  required String expireTime,
  required String buttonName,
  required Function() onButtonTap,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Dialog(
            insetPadding: const EdgeInsets.all(24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Column(
                children: [
                  const SpaceH40(),
                  Image.asset(
                    timerAsset,
                    height: 80,
                    width: 80,
                    package: 'simple_kit',
                  ),
                  const SpaceH20(),
                  Text(
                    description,
                    maxLines: 6,
                    textAlign: TextAlign.center,
                    style: sBodyText1Style.copyWith(
                      color: SColorsLight().grey1,
                    ),
                  ),
                  const SpaceH8(),
                  Text(
                    expireTime,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: sTextH5Style,
                  ),
                  const SpaceH36(),
                  SPrimaryButton1(
                    active: true,
                    name: buttonName,
                    onTap: onButtonTap,
                  ),
                  const SpaceH20(),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
