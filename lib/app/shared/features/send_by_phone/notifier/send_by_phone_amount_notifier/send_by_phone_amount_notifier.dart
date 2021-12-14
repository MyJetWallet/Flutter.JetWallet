import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import 'send_by_phone_amount_state.dart';

class SendByPhoneAmountNotifier extends StateNotifier<SendByPhoneAmountState> {
  SendByPhoneAmountNotifier() : super(const SendByPhoneAmountState());

  // ignore: unused_field
  static final _logger = Logger('SendByPhoneAmountNotifier');
}
