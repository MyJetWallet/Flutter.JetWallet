import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/preview_buy_with_asset_input.dart';
import 'preview_buy_with_asset_notifier.dart';
import 'preview_buy_with_asset_state.dart';

final previewBuyWithAssetNotipod = StateNotifierProvider.family.autoDispose<
    PreviewBuyWithAssetNotifier, ConvertState, PreviewBuyWithAssetInput>(
  (ref, input) {
    return PreviewBuyWithAssetNotifier(input, ref.read);
  },
);
