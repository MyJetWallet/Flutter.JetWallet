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
        header: SPaddingH24(
          child: SBigHeader(
            title: pin.screenUnion.when(
              enterPin: () {
                if (displayHeader) {
                  return pinN.screenDescription();
                } else {
                  return '';
                }
              },
              newPin: () => pinN.screenDescription(),
              confirmPin: () => pinN.screenDescription(),
            ),
            customIconButton: pin.screenUnion.when(
              enterPin: () {
                if (displayHeader) {
                  return null;
                } else {
                  return const SizedBox.shrink();
                }
              },
              newPin: () => null,
              confirmPin: () => null,
            ),
            onBackButtonTap: pin.screenUnion.when(
              enterPin: () {
                if (displayHeader) {
                  return null;
                } else {
                  return onbackButton;
                }
              },
              newPin: () => onbackButton,
              confirmPin: () => onbackButton,
            ),
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${intl.pinScreen_forgotYourPin}? ',
                    style: sBodyText2Style.copyWith(
                      color: colors.grey2,
                    ),
                  ),
                  InkWell(
                    highlightColor: colors.grey5,
                    onTap: () => logoutN.logout(),
                    child: Container(
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
                          intl.log_out,
                          style: sBodyText2Style.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
