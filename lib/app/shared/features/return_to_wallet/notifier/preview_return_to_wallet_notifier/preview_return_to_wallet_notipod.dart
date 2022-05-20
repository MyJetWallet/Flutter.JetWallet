import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/preview_return_to_wallet_input.dart';
import 'preview_return_to_wallet_notifier.dart';
import 'preview_return_to_wallet_state.dart';

final previewReturnToWalletNotipod = StateNotifierProvider.family.autoDispose<
    PreviewReturnToWalletNotifier,
    PreviewReturnToWalletState,
    PreviewReturnToWalletInput>(
  (ref, input) {
    return PreviewReturnToWalletNotifier(input, ref.read);
  },
);
