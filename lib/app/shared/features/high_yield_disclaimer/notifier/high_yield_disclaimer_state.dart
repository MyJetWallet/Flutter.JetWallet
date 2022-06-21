import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/disclaimer/model/disclaimers_response_model.dart';

part 'high_yield_disclaimer_state.freezed.dart';

@freezed
class HighYieldDisclaimerState with _$HighYieldDisclaimerState {
  const factory HighYieldDisclaimerState({
    String? imageUrl,
    @Default([]) List<DisclaimerModel> disclaimers,
    @Default(false) bool send,
    @Default(false) bool activeButton,
    @Default('') String disclaimerId,
    @Default('') String title,
    @Default('') String description,
    @Default([]) List<DisclaimerQuestionsModel> questions,
  }) = _HighYieldDisclaimerState;
}
