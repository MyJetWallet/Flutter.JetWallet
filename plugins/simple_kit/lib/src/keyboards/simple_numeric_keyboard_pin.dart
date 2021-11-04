import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';
import '../shared/helpers/biometrics_auth_helpers.dart';
import 'components/numeric_keyboard_frame.dart';
import 'components/numeric_keyboard_row.dart';
import 'constants.dart';

final _biometricStatusFpod = FutureProvider.autoDispose<BiometricStatus>(
  (ref) {
    return biometricStatus();
  },
  name: 'biometricStatusFpod',
);

/// Check on [face] and [fingerprint] keys, must be provided onResponse
/// from this Keyboard. \
/// If available biometrics such as [face] or [fingerprint] shows
/// BiometricButton.
class SNumericKeyboardPin extends ConsumerWidget {
  const SNumericKeyboardPin({
    this.hideBiometricButton,
    required this.onKeyPressed,
  });

  final bool? hideBiometricButton;
  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final biometricStatus = watch(_biometricStatusFpod);

    late Widget biometricIcon;
    late Widget biometricPressedIcon;
    late String biometricIconValue;

    biometricStatus.maybeWhen(
      data: (data) {
        biometricIcon = _iconBasedOnBiometricStatus(data);
        biometricPressedIcon = _iconPressedBasedOnBiometricStatus(data);
        biometricIconValue = _realValueOfBiometricButton(data);
      },
      orElse: () {
        biometricIcon = const SizedBox();
        biometricPressedIcon = const SizedBox();
        biometricIconValue = '';
      },
    );

    bool _hideBiometricButton() => biometricIcon is SizedBox;

    return NumericKeyboardFrame(
      height: 354.h,
      paddingTop: 40.h,
      lastRow: NumericKeyboardRow(
        icon1: biometricIcon,
        iconPressed1: biometricPressedIcon,
        realValue1: biometricIconValue,
        hideIcon1: hideBiometricButton ?? _hideBiometricButton(),
        frontKey2: zero,
        realValue2: zero,
        icon3: const SNumericKeyboardEraseIcon(),
        iconPressed3: const SNumericKeyboardErasePressedIcon(),
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

Widget _iconBasedOnBiometricStatus(BiometricStatus bioStatus) {
  if (bioStatus == BiometricStatus.face) {
    return const SNumericKeyboardFaceIdIcon();
  } else if (bioStatus == BiometricStatus.fingerprint) {
    return const SNumericKeyboardFingerprintIcon();
  } else {
    return const SizedBox();
  }
}

Widget _iconPressedBasedOnBiometricStatus(BiometricStatus bioStatus) {
  if (bioStatus == BiometricStatus.face) {
    return const SNumericKeyboardFaceIdPressedIcon();
  } else if (bioStatus == BiometricStatus.fingerprint) {
    return const SNumericKeyboardFingerprintPressedIcon();
  } else {
    return const SizedBox();
  }
}
