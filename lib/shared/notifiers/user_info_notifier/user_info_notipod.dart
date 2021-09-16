import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'user_info_notifier.dart';
import 'user_info_state.dart';

final userInfoNotipod = StateNotifierProvider<UserInfoNotifier, UserInfoState>(
  (ref) {
    return UserInfoNotifier(ref.read);
  },
  name: 'userInfoNotipod',
);
