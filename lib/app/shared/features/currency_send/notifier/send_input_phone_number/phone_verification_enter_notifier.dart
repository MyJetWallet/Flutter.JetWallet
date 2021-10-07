import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../shared/logging/levels.dart';
import 'send_input_phone_number_state.dart';

class SendInputPhoneNumberNotifier
    extends StateNotifier<SendInputPhoneNumberState> {
  SendInputPhoneNumberNotifier() : super(const SendInputPhoneNumberState());

  static final _logger = Logger('SendInputPhoneNumberNotifier');

  void updateValid({required bool valid}) {
    _logger.log(notifier, 'updateValid');

    state = state.copyWith(valid: valid);
  }

  void updatePhoneNumber(String? number) {
    _logger.log(notifier, 'updatePhoneNumber');

    state = state.copyWith(phoneNumber: number ?? '');
  }
}
