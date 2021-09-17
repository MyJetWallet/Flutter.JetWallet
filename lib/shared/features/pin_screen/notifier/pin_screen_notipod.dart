import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/pin_flow_union.dart';
import 'pin_screen_notifier.dart';
import 'pin_screen_state.dart';

final pinScreenNotipod = StateNotifierProvider.autoDispose
    .family<PinScreenNotifier, PinScreenState, PinFlowUnion>(
  (ref, flowUnion) {
    return PinScreenNotifier(ref.read, flowUnion);
  },
  name: 'pinScreenNotipod',
);
