import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/shared/providers/service_providers.dart';

import 'delete_profile_state.dart';

class DPNotifier extends StateNotifier<DPState> {
  DPNotifier({
    required this.read,
  }) : super(
          const DPState(),
        ) {
    _init();
  }

  final Reader read;

  void _init() {
    read(profileServicePod).deleteReasons(read(intlPod).localeName);

    //read(profileServicePod).info(read(intlPod).localeName);
  }

  void clickCheckbox() {
    state = state.copyWith(confitionCheckbox: !state.confitionCheckbox);
  }
}
