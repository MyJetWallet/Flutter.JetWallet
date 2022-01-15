import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view/phone_verification.dart';
import 'phone_verification_notifier.dart';
import 'phone_verification_state.dart';

final phoneVerificationNotipod = StateNotifierProvider.autoDispose.family<
    PhoneVerificationNotifier,
    PhoneVerificationState,
    PhoneVerificationArgs>(
  (ref, args) {
    return PhoneVerificationNotifier(ref.read, args);
  },
  name: 'phoneVerificationNotipod',
);
