import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifiers/credentials_notifier/credentials_notifier.dart';
import '../notifiers/credentials_notifier/state/credentials_state.dart';

final credentialsNotipod =
    StateNotifierProvider<CredentialsNotifier, CredentialsState>((ref) {
  return CredentialsNotifier();
});
