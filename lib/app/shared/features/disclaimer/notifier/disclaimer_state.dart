import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/disclaimer_model.dart';

part 'disclaimer_state.freezed.dart';

@freezed
class DisclaimerState with _$DisclaimerState {
  const factory DisclaimerState({
    String? imageUrl,
    @Default([]) List<DisclaimerModel> disclaimers,
    @Default(false) bool activeButton,
    @Default('') String disclaimerId,
    @Default('') String title,
    @Default('') String description,
    @Default([]) List<DisclaimerQuestionsModel> questions,
  }) = _DisclaimerState;
}
