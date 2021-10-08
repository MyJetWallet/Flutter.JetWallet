import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../logging/levels.dart';
import 'enter_phone_state.dart';

class EnterPhoneNotifier extends StateNotifier<EnterPhoneState> {
  EnterPhoneNotifier() : super(const EnterPhoneState());

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
