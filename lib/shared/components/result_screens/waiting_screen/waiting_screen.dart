import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../app/screens/navigation/provider/navigation_stpod.dart';
import '../../../helpers/navigate_to_router.dart';
import '../../../helpers/widget_size_from.dart';
import '../../../providers/device_size/device_size_pod.dart';
import '../../../providers/service_providers.dart';
import 'components/waiting_animation.dart';

class WaitingScreen extends HookWidget {
  const WaitingScreen({
    Key? key,
    this.onSuccess,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
    this.wasAction = false,
  }) : super(key: key);

  // Triggered when SuccessScreen is done
  final Function(BuildContext)? onSuccess;
  final String? primaryText;
  final String? secondaryText;
  final Widget? specialTextWidget;
  final bool wasAction;

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);
    final navigation = useProvider(navigationStpod);

    return SPageFrameWithPadding(
      child: Column(
        children: [
          Row(), // to expand Column in the cross axis
          const SpaceH86(),
          WaitingAnimation(
            widgetSize: widgetSizeFrom(deviceSize),
          ),
          Baseline(
            baseline: 136.0,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              primaryText ?? intl.waitingScreen_processing,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: sTextH2Style,
            ),
          ),
          Baseline(
            baseline: 31.4,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              secondaryText ?? intl.waitingScreen_description,
              maxLines: 10,
              textAlign: TextAlign.center,
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
          if (specialTextWidget != null) specialTextWidget!,
          if (wasAction) ...[
            const Spacer(),
            SPaddingH24(
              child: SSecondaryButton1(
                active: true,
                name: intl.previewBuyWithUmlimint_skipWait,
                onTap: () {
                  navigateToRouter(context.read);
                  navigation.state = 1;
                },
              ),
            ),
            const SpaceH24(),
          ],
        ],
      ),
    );
  }
}
