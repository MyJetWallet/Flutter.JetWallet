import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../service/services/signal_r/model/earn_profile_model.dart';

part 'earn_profile_state.freezed.dart';

@freezed
class EarnProfileState with _$EarnProfileState {
  const factory EarnProfileState({
    EarnProfileModel? earnProfile,
  }) = _EarnProfileState;
}
