import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../../../shared/providers/service_providers.dart';
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
    read(profileServicePod).deleteReasons(read(intlPod).localeName).then(
          (value) => {
            state = state.copyWith(selectedDeleteReason: []),
            state = state.copyWith(deleteReason: value),
          },
        );
  }

  bool isAlreadySelected(int index) {
    if (state.selectedDeleteReason.contains(state.deleteReason[index])) {
      return true;
    } else {
      return false;
    }
  }

  void selectDeleteReason(int index) {
    if (isAlreadySelected(index)) {
      state.selectedDeleteReason
          .removeWhere((element) => element == state.deleteReason[index]);

      state = state.copyWith(selectedDeleteReason: state.selectedDeleteReason);
    } else {
      state.selectedDeleteReason.add(state.deleteReason[index]);

      state = state.copyWith(selectedDeleteReason: state.selectedDeleteReason);
    }
  }

  Future<void> deleteProfile() async {
    await read(profileServicePod)
        .deleteProfile(
      read(authInfoNotipod).deleteToken,
      state.selectedDeleteReason.map((e) => e.reasonId!).toList(),
    )
        .then(
      (value) async {
        await read(logoutNotipod.notifier).logout().then(
              (value) => navigateToRouter(read),
            );
      },
    );
  }

  void clickCheckbox() {
    state = state.copyWith(confitionCheckbox: !state.confitionCheckbox);
  }
}
