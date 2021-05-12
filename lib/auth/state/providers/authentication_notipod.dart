import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifiers/authentication_notifier.dart';

final authenticationNotipod =
    StateNotifierProvider<AuthenticationNotifier, void>((ref) {
  return AuthenticationNotifier(ref.read);
});
