import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/helpers/biometrics_auth_helpers.dart';
import 'components/keyboard_row.dart';
import 'components/number_keyboard_frame.dart';
import 'key_constants.dart';

final _biometricStatusFpod = FutureProvider.autoDispose<BiometricStatus>(
  (ref) {
    return biometricStatus();
  },
  name: 'biometricStatusFpod',
);

/// Check on [face] and [fingerprint] keys must be provided onResponse
/// from this Keyboard. \
/// If available biometrics such as [face] or [fingerprint] shows
/// BiometricButton.
class NumberKeyboardPin extends HookWidget {
  const NumberKeyboardPin({
    this.hideBiometricButton,
    required this.onKeyPressed,
  });

  final bool? hideBiometricButton;
  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    final biometricStatus = useProvider(_biometricStatusFpod);
    late Widget biometricButton;
    late String biometricButtonValue;

    biometricStatus.maybeWhen(
      data: (data) {
        biometricButton = _childBasedOnBiometricStatus(data);
        biometricButtonValue = _realValueOfBiometricButton(data);
      },
      orElse: () {
        biometricButton = const SizedBox();
        biometricButtonValue = '';
      },
    );

    bool _hideBiometricButton() => biometricButton is SizedBox;

    return NumberKeyboardFrame(
      lastRow: KeyboardRow(
        child1: biometricButton,
        realValue1: biometricButtonValue,
        hideChild1: hideBiometricButton ?? _hideBiometricButton(),
        frontKey2: zero,
        realValue2: zero,
        frontKey3: backspace,
        realValue3: backspace,
        onKeyPressed: onKeyPressed,
      ),
      onKeyPressed: onKeyPressed,
    );
  }
}

String _realValueOfBiometricButton(BiometricStatus bioStatus) {
  if (bioStatus == BiometricStatus.face) {
    return face;
  } else if (bioStatus == BiometricStatus.fingerprint) {
    return fingerprint;
  } else {
    return '';
  }
}

Widget _childBasedOnBiometricStatus(BiometricStatus bioStatus) {
  if (bioStatus == BiometricStatus.face) {
    return Icon(
      Icons.face,
      size: 40.r,
    );
  } else if (bioStatus == BiometricStatus.fingerprint) {
    return Icon(
      Icons.fingerprint,
      size: 40.r,
    );
  } else {
    return const SizedBox();
  }
}
