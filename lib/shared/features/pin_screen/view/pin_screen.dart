import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/shared/components/number_keyboard/number_keyboard_pin.dart';
import '../../../components/page_frame/page_frame.dart';
import '../../../components/spacers.dart';
import '../../../helpers/navigator_push.dart';
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
    required this.union,
  }) : super(key: key);

  final PinFlowUnion union;

  static void push(BuildContext context, PinFlowUnion union) {
    navigatorPush(context, PinScreen(union: union));
  }

  @override
  Widget build(BuildContext context) {
    final state = useProvider(pinScreenNotipod(union));
    final notifier = useProvider(pinScreenNotipod(union).notifier);

    return PageFrame(
      header: state.screenHeader,
      onBackButton: () => Navigator.pop(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: PinText(
              text: state.screenDescription,
              fontSize: 16.sp,
            ),
          ),
          const SpaceH40(),
          ShakeWidget(
            key: state.shakePinKey,
            shakeDuration: pinBoxErrorDuration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int id = 1; id <= pinLength; id++)
                  PinBox(
                    state: state.boxState(id),
                  ),
              ],
            ),
          ),
          const SpaceH20(),
          ShakeWidget(
            key: state.shakeTextKey,
            shakeDuration: pinBoxErrorDuration,
            child: state.pinState == PinBoxEnum.error
                ? PinText(
                    text: 'Wrong PIN',
                    color: state.pinState.color,
                  )
                : const SizedBox(),
          ),
          const Spacer(),
          NumberKeyboardPin(
            hideBiometricButton: state.hideBiometricButton,
            onKeyPressed: (value) => notifier.updatePin(value),
          ),
        ],
      ),
    );
  }
}
