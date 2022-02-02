import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'update_notifier.dart';
import 'update_union.dart';

final updateNotipod = StateNotifierProvider<UpdateNotifier, UpdateUnion>(
  (ref) {
    return UpdateNotifier(ref.read);
  },
  name: 'updateNotipod',
);
