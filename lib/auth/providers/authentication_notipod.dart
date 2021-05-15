import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../service_providers.dart';
import '../notifiers/authentication_notifier/authentication_notifier.dart';
import '../notifiers/authentication_notifier/union/authentication_union.dart';

final authenticationNotipod =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationUnion>((ref) {
  final authenticationService = ref.read(authenticationServicePod);

  return AuthenticationNotifier(
    read: ref.read,
    authenticationService: authenticationService,
  );
});
