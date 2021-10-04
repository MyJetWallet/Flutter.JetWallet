import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../logging/levels.dart';
import '../../model/phone_verification_trigger_union.dart';
import 'phone_verification_enter_state.dart';

class PhoneVerificationEnterNotifier
    extends StateNotifier<PhoneVerificationEnterState> {
  PhoneVerificationEnterNotifier(
    this.trigger,
  ) : super(const PhoneVerificationEnterState());

  final PhoneVerificationTriggerUnion trigger;

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
