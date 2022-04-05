import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SResendButton extends StatefulWidget {
  const SResendButton({
    Key? key,
    this.active = true,
    required this.onTap,
    required this.timer,
  }) : super(key: key);

  final bool active;
  final Function() onTap;
  final int timer;

  @override
  _SResendButton createState() => _SResendButton();
}

class _SResendButton extends State<SResendButton>
    with RestorationMixin<SResendButton> {
  final _timer = RestorableInt(0);

  @override
  String? get restorationId => 'ResendButtonRest';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_timer, 'tmr');
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  void _setTimer(int newValue) {
    setState(() {
      _timer.value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    _setTimer(widget.timer);
    return Column(
      children: [
        Center(
          child: Text(
            _timer.value > 0
                ? 'You can resend in ${_timer.value} seconds'
                : "Didn't receive the code?",
            style: sCaptionTextStyle.copyWith(
              color: SColorsLight().grey2,
            ),
          ),
        ),
        const SpaceH10(),
        Visibility(
          visible: _timer.value <= 0,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: STextButton1(
            active: widget.active,
            name: 'Resend',
            onTap: widget.onTap,
          ),
        ),
      ],
    );
  }
}
