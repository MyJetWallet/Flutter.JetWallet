import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/currency_model.dart';
import 'withdrawal_preview_notifier.dart';
import 'withdrawal_preview_state.dart';

final withdrawalPreviewNotipod = StateNotifierProvider.autoDispose
    .family<WithdrawalPreviewNotifier, WithdrawalPreviewState, CurrencyModel>(
  (ref, currency) {
    return WithdrawalPreviewNotifier(ref.read, currency);
  },
);
