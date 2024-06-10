import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Returns [true] if BioAuth was successful else [false]
Future<bool> makeAuthWithBiometrics(String localizedReasonText) async {
  try {
    final auth = LocalAuthentication();

    final availableBio = await auth.getAvailableBiometrics();

    final face = availableBio.contains(BiometricType.face);
    final fingerprint = availableBio.contains(BiometricType.fingerprint) ||
        availableBio.contains(BiometricType.strong) ||
        availableBio.contains(BiometricType.weak);

    if (face || fingerprint) {
      final result = await auth.authenticate(
        localizedReason: localizedReasonText,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      return result;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

enum BiometricStatus { face, fingerprint, none }

Future<BiometricStatus> biometricStatus() async {
  final auth = LocalAuthentication();

  final availableBio = kIsWeb ? [] : await auth.getAvailableBiometrics();

  if (availableBio.contains(BiometricType.face)) {
    return BiometricStatus.face;
  } else if (availableBio.contains(BiometricType.fingerprint) ||
      availableBio.contains(BiometricType.strong) ||
      availableBio.contains(BiometricType.weak)) {
    return BiometricStatus.fingerprint;
  } else {
    return BiometricStatus.none;
  }
}
