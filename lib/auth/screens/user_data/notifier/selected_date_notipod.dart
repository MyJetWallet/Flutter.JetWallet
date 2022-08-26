import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'user_data_notifier.dart';
import 'user_data_state.dart';

final userDataNotipod =
    StateNotifierProvider.autoDispose<UserDataNotifier, UserDataState>((ref) {
  return UserDataNotifier(ref.read);
});
