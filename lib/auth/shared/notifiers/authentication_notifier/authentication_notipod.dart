import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'authentication_notifier.dart';
import 'authentication_union.dart';

final authenticationNotipod =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationUnion>(
  (ref) {
    return AuthenticationNotifier(ref.read);
  },
);
