import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/credentials_notifier/credentials_notifier.dart';
import '../notifier/credentials_notifier/credentials_state.dart';

final credentialsNotipod =
    StateNotifierProvider<CredentialsNotifier, CredentialsState>(
  (ref) {
    return CredentialsNotifier();
  },
);
