import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/helpers/biometrics_auth_helpers.dart';

final biometricStatusFpod = FutureProvider.autoDispose<BiometricStatus>(
  (ref) {
    return biometricStatus();
  },
  name: 'biometricStatusFpod',
);
