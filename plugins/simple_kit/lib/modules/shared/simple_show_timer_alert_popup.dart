import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:mobx/mobx.dart';

import '../../../simple_kit.dart';

part 'simple_show_timer_alert_popup.g.dart';

void sShowTimerAlertPopup({
  required BuildContext context,
  required String description,
  required String buttonName,
  required String expireIn,
  required Function() onButtonTap,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return _TimerAlertPopup(
        expireIn: expireIn,
        description: description,
        buttonName: buttonName,
        onButtonTap: onButtonTap,
      );
    },
  );
}

class _TimerState = __TimerStateBase with _$_TimerState;

abstract class __TimerStateBase with Store {
  __TimerStateBase(this.duration) {
    //start();
  }

  @observable
  late Duration duration;

  late Timer timer;

  void start() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (duration.inSeconds > 0) {
          duration = Duration(seconds: duration.inSeconds - 1);
        } else {
          timer.cancel();
        }
      },
    );
  }

  void dispose() {
    timer.cancel();
  }
}

class _TimerAlertPopup extends StatelessObserverWidget {
  const _TimerAlertPopup({
    Key? key,
    required this.expireIn,
    required this.description,
    required this.buttonName,
    required this.onButtonTap,
  }) : super(key: key);

  final String expireIn;
  final String description;
  final String buttonName;
  final Function() onButtonTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    //final expire = _TimerState(expireIn);

    //if (expire.duration.inSeconds == 0) Navigator.pop(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Dialog(
          insetPadding: const EdgeInsets.all(24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Column(
              children: [
                const SpaceH40(),
                Image.asset(
                  timerAsset,
                  height: 80,
                  width: 80,
                  package: 'simple_kit',
                ),
                const SpaceH20(),
                Text(
                  description,
                  maxLines: 6,
                  textAlign: TextAlign.center,
                  style: sBodyText1Style.copyWith(
                    color: SColorsLight().grey1,
                  ),
                ),
                const SpaceH8(),
                Text(
                  expireIn,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: sTextH5Style,
                ),
                const SpaceH36(),
                SPrimaryButton1(
                  active: true,
                  name: buttonName,
                  onTap: onButtonTap,
                ),
                const SpaceH20(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
