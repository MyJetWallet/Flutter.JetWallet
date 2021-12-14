import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import 'send_by_phone_confirm_state.dart';

class SendByPhoneConfirmNotifier
    extends StateNotifier<SendByPhoneConfirmState> {
  SendByPhoneConfirmNotifier() : super(const SendByPhoneConfirmState());

  // ignore: unused_field
  static final _logger = Logger('SendByPhoneConfirmNotifier');
}
