import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'referral_code_link_notifier.dart';
import 'referral_code_link_state.dart';

final referralCodeLinkNotipod = StateNotifierProvider.autoDispose<
    ReferralCodeLinkNotifier, ReferralCodeLinkState>(
  (ref) {
    return ReferralCodeLinkNotifier(read: ref.read);
  },
);
