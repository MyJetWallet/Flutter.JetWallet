import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helper/quote_timer.dart';

final quoteTimerSpod = StreamProvider.autoDispose.family<int, int>(
  (ref, expirationTime) {
    return quoteTimer(expirationTime - 1);
  },
);
