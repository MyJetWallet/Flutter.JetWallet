import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'kyc_selfie_notifier.dart';
import 'kyc_selfie_state.dart';

final kycSelfieNotipod = StateNotifierProvider
    .autoDispose<KycSelfieNotifier, KycSelfieState>(
      (ref) {

    return KycSelfieNotifier(
      read: ref.read,
    );
  },
);
