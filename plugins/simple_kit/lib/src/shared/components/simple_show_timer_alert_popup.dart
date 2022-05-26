import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

void sShowTimerAlertPopup({
  required BuildContext context,
  required String description,
  required String buttonName,
  required Duration expireIn,
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

class _TimerAlertPopup extends ConsumerWidget {
  const _TimerAlertPopup({
    Key? key,
    required this.expireIn,
    required this.description,
    required this.buttonName,
    required this.onButtonTap,
  }) : super(key: key);

  final Duration expireIn;
  final String description;
  final String buttonName;
  final Function() onButtonTap;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final expire = watch(_timerNotipod(expireIn));

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
                  _format(expire),
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

class _TimerNotifier extends StateNotifier<Duration> {
  _TimerNotifier(this.duration) : super(duration) {
    start();
  }

  final Duration duration;

  late Timer timer;

  void start() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        state = Duration(seconds: state.inSeconds - 1);
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

final _timerNotipod = StateNotifierProvider.autoDispose
    .family<_TimerNotifier, Duration, Duration>(
  (ref, duration) {
    return _TimerNotifier(duration);
  },
  name: '_timerNotipod',
);

String _format(Duration duration) {
  final result = StringBuffer();

  for (final char in duration.toString().split('')) {
    if (char == '.') break;
    result.write(char);
  }

  return result.toString();
}
