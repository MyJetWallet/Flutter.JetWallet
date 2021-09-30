import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../logging/levels.dart';
import 'phone_verification_enter_state.dart';

class PhoneVerificationEnterNotifier
    extends StateNotifier<PhoneVerificationEnterState> {
  PhoneVerificationEnterNotifier() : super(const PhoneVerificationEnterState());

  static final _logger = Logger('PhoneVerificationEnterNotifier');

  void updateValid({required bool valid}) {
    _logger.log(notifier, 'updateValid');

    state = state.copyWith(valid: valid);
  }

  void updatePhoneNumber(String? number) {
    _logger.log(notifier, 'updatePhoneNumber');

    state = state.copyWith(phoneNumber: number);
  }
}
