import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../shared/logging/levels.dart';
import 'change_phone_state.dart';

class ChangePhoneNotifier extends StateNotifier<ChangePhoneState> {
  ChangePhoneNotifier(this.read) : super(const ChangePhoneState());

  final Reader read;

  static final _logger = Logger('ChangePhoneNotifier');

  void updatePhone(String phone) {
    _logger.log(notifier, 'updatePhone');

    state = state.copyWith(phone: phone);
  }

  void updateIsoCode(String isoCode) {
    _logger.log(notifier, 'updateIsoCode');

    state = state.copyWith(isoCode: isoCode);

    updatePhone(state.isoCode);
  }
}
