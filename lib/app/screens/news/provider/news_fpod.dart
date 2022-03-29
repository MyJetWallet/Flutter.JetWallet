import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../notifier/news_notipod.dart';

final newsInitFpod = FutureProvider.autoDispose<void>(
  (ref) async {
    try {
      final newsN = ref.read(newsNotipod.notifier);

      await newsN.init(null);
    } catch (_) {
      ref.read(sNotificationNotipod.notifier).showError(
            'Something went wrong',
            id: 2,
          );
    }
  },
);
