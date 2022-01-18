import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../helpers/navigate_to_router.dart';
import '../../../helpers/navigator_push.dart';
import 'components/success_animation.dart';

class SuccessScreen extends HookWidget {
  const SuccessScreen({
    Key? key,
    this.then,
    this.onSuccess,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
  }) : super(key: key);

  // Triggered after onSuccess callback
  final Function()? then;
  // Triggered when SuccessScreen is done
  final Function()? onSuccess;
  final String? primaryText;
  final String? secondaryText;
  final Widget? specialTextWidget;

  static void push({
    Key? key,
    Function()? then,
    String? primaryText,
    String? secondaryText,
    Widget? specialTextWidget,
    required BuildContext context,
  }) {
    navigatorPush(
      context,
      SuccessScreen(
        primaryText: primaryText,
        secondaryText: secondaryText,
        specialTextWidget: specialTextWidget,
      ),
      then,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return ProviderListener<int>(
      provider: timerNotipod(3),
      onChange: (context, value) {
        if (value == 0) {
          if (onSuccess == null) {
            navigateToRouter(context.read);
          } else {
            onSuccess!.call();
          }
          then?.call();
        }
      },
      child: SPageFrameWithPadding(
        child: Column(
          children: [
            Row(), // to expand Column in the cross axis
            const SpaceH86(),
            const SuccessAnimation(),
            Baseline(
              baseline: 136.h,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                primaryText ?? 'Success',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: sTextH2Style,
              ),
            ),
            if (secondaryText != null)
              Baseline(
                baseline: 31.4.h,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  secondaryText!,
                  maxLines: 10,
                  textAlign: TextAlign.center,
                  style: sBodyText1Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
              ),
            if (specialTextWidget != null) specialTextWidget!
          ],
        ),
      ),
    );
  }
}
