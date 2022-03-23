import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../notifier/news_notipod.dart';

final newsInitFpod = FutureProvider.family.autoDispose<void, String?>(
  (ref, assetId) async {
    try {
      final newsN = ref.read(
        newsNotipod(
          assetId,
        ).notifier,
      );

      await newsN.initNews();
    } catch (_) {
      ref.read(sNotificationNotipod.notifier).showError(
            'Something went wrong',
            id: 2,
          );
    }
  },
);
