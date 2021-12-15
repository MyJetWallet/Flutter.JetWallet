import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import 'send_by_phone_input_state.dart';

class SendByPhoneInputNotifier extends StateNotifier<SendByPhoneInputState> {
  SendByPhoneInputNotifier() : super(const SendByPhoneInputState());

  // ignore: unused_field
  static final _logger = Logger('SendByPhoneInputNotifier');
}
