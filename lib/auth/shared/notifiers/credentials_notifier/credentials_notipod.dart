import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'credentials_notifier.dart';
import 'credentials_state.dart';

final credentialsNotipod =
    StateNotifierProvider.autoDispose<CredentialsNotifier, CredentialsState>(
  (ref) {
    return CredentialsNotifier();
  },
);
