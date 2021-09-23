import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/shared/components/number_keyboard/number_keyboard_pin.dart';
import '../../../components/loader.dart';
import '../../../components/page_frame/page_frame.dart';
import '../../../components/spacers.dart';
import '../../../helpers/navigator_push.dart';
import '../../../helpers/show_plain_snackbar.dart';
import '../../../notifiers/logout_notifier/logout_notipod.dart';
import '../../../notifiers/logout_notifier/logout_union.dart';
import '../model/pin_box_enum.dart';
import '../model/pin_flow_union.dart';
import '../notifier/pin_screen_notifier.dart';
import '../notifier/pin_screen_notipod.dart';
import 'components/pin_box.dart';
import 'components/pin_text.dart';
import 'components/shake_widget/shake_widget.dart';

class PinScreen extends HookWidget {
  const PinScreen({
    Key? key,
    this.cannotLeave = false,
    required this.union,
  }) : super(key: key);

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
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);

    Function()? onbackButton;
    String? header;

    if (union == const Verification()) {
      onbackButton = () => logoutN.logout();
      header = 'Simple';
    } else if (cannotLeave) {
      onbackButton = null;
    } else {
      onbackButton = () => Navigator.pop(context);
      header = pin.screenHeader;
    }

    return ProviderListener<LogoutUnion>(
      provider: logoutNotipod,
      onChange: (context, union) {
        union.when(
          result: (error, st) {
            if (error != null) {
              showPlainSnackbar(context, '$error');
            }
          },
          loading: () {},
        );
      },
      child: logout.when(
        result: (_, __) {
          return WillPopScope(
            onWillPop: () => Future.value(!cannotLeave),
            child: PageFrame(
              header: header,
              onBackButton: onbackButton,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: PinText(
                      text: pin.screenDescription,
                      fontSize: 16.sp,
                    ),
                  ),
                  const SpaceH40(),
                  ShakeWidget(
                    key: pin.shakePinKey,
                    shakeDuration: pinBoxErrorDuration,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int id = 1; id <= pinLength; id++)
                          PinBox(
                            state: pin.boxState(id),
                          ),
                      ],
                    ),
                  ),
                  const SpaceH20(),
                  ShakeWidget(
                    key: pin.shakeTextKey,
                    shakeDuration: pinBoxErrorDuration,
                    child: pin.pinState == PinBoxEnum.error
                        ? PinText(
                            text: 'Wrong PIN',
                            color: pin.pinState.color,
                          )
                        : const SizedBox(),
                  ),
                  const Spacer(),
                  if (pin.lockTime != 0)
                    PinText(
                      text: 'Input is disabled. '
                          'Try again in ${pin.lockTime} seconds',
                    )
                  else ...[
                    NumberKeyboardPin(
                      hideBiometricButton: pin.hideBiometricButton,
                      onKeyPressed: (value) => pinN.updatePin(value),
                    ),
                  ]
                ],
              ),
            ),
          );
        },
        loading: () => const Loader(),
      ),
    );
  }
}
