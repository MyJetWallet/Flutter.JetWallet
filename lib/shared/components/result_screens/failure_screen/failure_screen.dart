import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../helpers/navigator_push.dart';
import 'components/failure_animation.dart';

class FailureScreen extends HookWidget {
  const FailureScreen({
    Key? key,
    this.secondaryText,
    this.secondaryButtonName,
    this.onSecondaryButtonTap,
    required this.primaryText,
    required this.primaryButtonName,
    required this.onPrimaryButtonTap,
  }) : super(key: key);

  final String? secondaryText;
  final String? secondaryButtonName;
  final Function()? onSecondaryButtonTap;
  final String primaryText;
  final String primaryButtonName;
  final Function() onPrimaryButtonTap;

  static void push({
    Key? key,
    String? secondaryText,
    String? secondaryButtonName,
    Function()? onSecondaryButtonTap,
    required BuildContext context,
    required String primaryText,
    required String primaryButtonName,
    required Function() onPrimaryButtonTap,
  }) {
    navigatorPush(
      context,
      FailureScreen(
        primaryText: primaryText,
        secondaryText: secondaryText,
        primaryButtonName: primaryButtonName,
        secondaryButtonName: secondaryButtonName,
        onPrimaryButtonTap: onPrimaryButtonTap,
        onSecondaryButtonTap: onSecondaryButtonTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SPageFrameWithPadding(
      child: Column(
        children: [
          const SpaceH86(),
          const FailureAnimation(),
          Baseline(
            baseline: 92.0,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              primaryText,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: sTextH2Style,
            ),
          ),
          if (secondaryText != null)
            Baseline(
              baseline: 31.4,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                secondaryText!,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: sBodyText1Style.copyWith(
                  color: colors.grey1,
                ),
              ),
            ),
          const Spacer(),
          SPrimaryButton1(
            active: true,
            name: primaryButtonName,
            onTap: onPrimaryButtonTap,
          ),
          const SpaceH10(),
          if (secondaryButtonName != null && onSecondaryButtonTap != null)
            STextButton1(
              active: true,
              name: secondaryButtonName!,
              onTap: onSecondaryButtonTap!,
            ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
