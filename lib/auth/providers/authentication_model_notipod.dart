import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../service/services/authentication/model/authentication_model.dart';
import '../notifiers/authentication_model_notifier.dart';

final authenticationModelNotipod =
    StateNotifierProvider<AuthenticationModelNotifier, AuthenticationModel>(
  (ref) {
    return AuthenticationModelNotifier();
  },
);
