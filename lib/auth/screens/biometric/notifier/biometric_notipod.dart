import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'biometric_notifier.dart';
import 'biometric_state.dart';

final biometricNotipod =
    StateNotifierProvider.autoDispose<BiometricNotifier, BiometricState>(
  (ref) {
    return BiometricNotifier(ref.read);
  },
  name: 'BiometricNotipod',
);
