import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/auth_model.dart';
import 'auth_model_notifier.dart';

final authModelNotipod =
    StateNotifierProvider<AuthModelNotifier, AuthModel>((ref) {
  return AuthModelNotifier();
});
