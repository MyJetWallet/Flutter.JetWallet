import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_info_notifier.dart';
import 'auth_info_state.dart';

final authInfoNotipod =
    StateNotifierProvider<AuthInfoNotifier, AuthInfoState>((ref) {
  return AuthInfoNotifier(ref.read);
});
