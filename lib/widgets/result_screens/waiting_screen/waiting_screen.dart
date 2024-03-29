import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/widgets/waiting_animation.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'WaitingScreenRouter')
class WaitingScreen extends StatelessObserverWidget {
  const WaitingScreen({
    super.key,
    this.onSuccess,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
    this.wasAction = false,
    required this.onSkip,
  });

  // Triggered when SuccessScreen is done
  final Function(BuildContext)? onSuccess;
  final Function() onSkip;
  final String? primaryText;
  final String? secondaryText;
  final Widget? specialTextWidget;
  final bool wasAction;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      child: Column(
        children: [
          const Row(), // to expand Column in the cross axis
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
          if (secondaryText != null)
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
            SSecondaryButton1(
              active: true,
              name: intl.previewBuyWithUmlimint_close,
              onTap: () {
                onSkip();
                navigateToRouter();
              },
            ),
            const SpaceH42(),
          ],
        ],
      ),
    );
  }
}
