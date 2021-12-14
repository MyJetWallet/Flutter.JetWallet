import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import 'send_by_phone_preview_state.dart';

class SendByPhonePreviewNotifier
    extends StateNotifier<SendByPhonePreviewState> {
  SendByPhonePreviewNotifier() : super(const SendByPhonePreviewState());

  // ignore: unused_field
  static final _logger = Logger('SendByPhonePreviewNotifier');
}
