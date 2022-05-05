import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/key_value_model.dart';

import '../provider/key_value_spod.dart';
import 'key_value_notifier.dart';

final keyValueNotipod =
    StateNotifierProvider.autoDispose<KeyValueNotifier, KeyValueModel>(
  (ref) {
    final keyValue = ref.watch(keyValueSpod);

    return KeyValueNotifier(
      read: ref.read,
      keyValue: keyValue,
    );
  },
);
