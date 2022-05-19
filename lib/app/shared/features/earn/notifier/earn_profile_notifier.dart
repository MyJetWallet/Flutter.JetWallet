import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/earn_profile_model.dart';
import 'earn_profile_state.dart';

class EarnProfileNotifier extends StateNotifier<EarnProfileState> {
  EarnProfileNotifier(
    this.read,
    this.earnProfile,
  ) : super(
          const EarnProfileState(),
        ) {
    earnProfile.whenData(
          (data) {
        state = state.copyWith(
          earnProfile: data,
        );
      },
    );
  }

  final Reader read;
  final AsyncValue<EarnProfileModel> earnProfile;
}
