import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../helpers/navigator_push.dart';
import '../../../notifiers/logout_notifier/logout_notipod.dart';
import '../../../providers/service_providers.dart';
import '../../../services/remote_config_service/remote_config_values.dart';
import '../model/pin_flow_union.dart';
import '../notifier/pin_screen_notifier.dart';
import '../notifier/pin_screen_notipod.dart';
import 'components/pin_box.dart';
import 'components/shake_widget/shake_widget.dart';

class PinScreen extends HookWidget {
  const PinScreen({
    Key? key,
    this.displayHeader = true,
    this.cannotLeave = false,
    required this.union,
  }) : super(key: key);

  final bool displayHeader;
  final bool cannotLeave;
  final PinFlowUnion union;

  static void push(
    BuildContext context,
    PinFlowUnion union, {
    bool cannotLeave = false,
  }) {
    navigatorPush(
      context,
      PinScreen(
        union: union,
        cannotLeave: cannotLeave,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pin = useProvider(pinScreenNotipod(union));
    final pinN = useProvider(pinScreenNotipod(union).notifier);
    final logoutN = useProvider(logoutNotipod.notifier);
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);

    Function()? onbackButton;

    if (union is Verification || union is Setup) {
      onbackButton = () => logoutN.logout();
    } else if (cannotLeave) {
      onbackButton = null;
    } else {
      onbackButton = () => Navigator.pop(context);
    }

    return WillPopScope(
      onWillPop: () => Future.value(!cannotLeave),
      child: SPageFrame(
        header: Column(
          children: [
            pin.screenUnion.when(
              enterPin: () {
                if (displayHeader) {
                  return SAuthHeader(
                    title: pinN.screenDescription(),
                  );
                } else {
                  return const SizedBox();
                }
              },
              confirmPin: () {
                return SAuthHeader(
                  title: pinN.screenDescription(),
                    progressValue: 100,
                  onBackButtonTap: () {
                    onbackButton!();
                  },
                );
              },
              newPin: () {
                return SAuthHeader(
                  title: pinN.screenDescription(),
                  progressValue: 100,
                  onBackButtonTap: () {
                    onbackButton!();
                  },
                );
              },
            ),
          ],
        ),
        child: Column(
          children: [
            Spacer(flex: displayHeader?1:2,),
            ShakeWidget(
              key: pin.shakePinKey,
              shakeDuration: pinBoxErrorDuration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int id = 1; id <= localPinLength; id++)
                    PinBox(
                      state: pin.boxState(id),
                    ),
                ],
              ),
            ),
            const Spacer(),
            if (!displayHeader)
              InkWell(
                highlightColor: colors.grey5,
                onTap: () => sShowAlertPopup(
                  context,
                  primaryText: intl.forgot_pass_dialog_title,
                  secondaryText: intl.forgot_pass_dialog_text,
                  primaryButtonType: SButtonType.primary3,
                  primaryButtonName: intl.forgot_pass_dialog_btn_reset,
                  image: Image.asset(
                    ellipsisAsset,
                    width: 80,
                    height: 80,
                    package: 'simple_kit',
                  ),
                  onPrimaryButtonTap: () {
                    logoutN.logout(resetPin: true);
                    Navigator.pop(context);
                  },
                  secondaryButtonName: intl.forgot_pass_dialog_btn_cancel,
                  onSecondaryButtonTap: () {
                    Navigator.pop(context);
                  },
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: colors.black,
                      ),
                    ),
                  ),
                  child: Baseline(
                    baselineType: TextBaseline.alphabetic,
                    baseline: 22,
                    child: Text(
                      '${intl.pinScreen_forgotYourPin}?',
                      style: sBodyText2Style
                    ,),
                  ),
                ),
              ),
            if (!displayHeader) const SpaceH34(),
            if (displayHeader) const SpaceH40(),
            SNumericKeyboardPin(
              hideBiometricButton: pin.hideBiometricButton,
              onKeyPressed: (value) => pinN.updatePin(value),
            ),
          ],
        ),
      ),
    );
  }
}
