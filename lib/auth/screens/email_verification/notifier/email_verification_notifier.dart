import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'email_verification_state.dart';

class EmailVerificationNotifier extends StateNotifier<EmailVerificationState> {
  EmailVerificationNotifier(this.initial) : super(initial);

  final EmailVerificationState initial;

  void updateCode(String code) {
    state = state.copyWith(code: code);
  }

  // TODO Send Code
  
  // TODO Verify Code
}
