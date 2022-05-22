import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/components/result_screens/success_screen/components/success_animation.dart';
import '../../../../../../../../shared/helpers/analytics.dart';
import '../../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../../../../shared/helpers/widget_size_from.dart';
import '../../../../../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../../../shared/providers/service_providers.dart';
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
    final deviceSize = useProvider(deviceSizePod);
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    useProvider(kycStartFpod);

    analytics(() => sAnalytics.kycSuccessPageView());

    return ProviderListener<int>(
      provider: timerNotipod(3),
      onChange: (context, value) {},
      child: SPageFrameWithPadding(
        child: Column(
          children: [
            const Spacer(),
            SuccessAnimation(
              widgetSize: widgetSizeFrom(deviceSize),
            ),
            Baseline(
              baseline: 136.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                primaryText ?? intl.successKycScreen_success,
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
                name: intl.successKycScreen_done,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
