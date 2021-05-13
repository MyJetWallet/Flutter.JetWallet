import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifiers/authentication_notifier/authentication_notifier.dart';
import '../notifiers/authentication_notifier/union/authentication_union.dart';

final authenticationNotipod =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationUnion>((ref) {
  return AuthenticationNotifier(ref.read);
});
