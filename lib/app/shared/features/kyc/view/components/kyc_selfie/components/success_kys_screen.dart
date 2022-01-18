import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/components/result_screens/success_screen/components/success_animation.dart';
import '../../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../provider/kyc_start_fpod.dart';

class SuccessKycScreen extends HookWidget {
  const SuccessKycScreen({
    Key? key,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
  }) : super(key: key);

  final String? primaryText;
  final String? secondaryText;
  final Widget? specialTextWidget;

  static void pushReplacement({
    Key? key,
    String? primaryText,
    String? secondaryText,
    Widget? specialTextWidget,
    required BuildContext context,
  }) {
    navigatorPushReplacement(
      context,
      SuccessKycScreen(
        primaryText: primaryText,
        secondaryText: secondaryText,
        specialTextWidget: specialTextWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    useProvider(kycStartFpod);

    return SPageFrameWithPadding(
      child: Column(
        children: [
          const Spacer(),
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
          if (specialTextWidget != null) specialTextWidget!,

          Padding(
            padding: const EdgeInsets.only(
              bottom: 24.0,
              top: 40.0,
            ),
            child: SPrimaryButton2(
              active: true,
              name: 'Done',
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
