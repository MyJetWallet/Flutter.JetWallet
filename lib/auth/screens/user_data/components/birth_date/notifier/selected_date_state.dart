import 'package:freezed_annotation/freezed_annotation.dart';

part 'selected_date_state.freezed.dart';

@freezed
class SelectedDateState with _$SelectedDateState {
  const factory SelectedDateState({
    @Default('') String selectedDate,
  }) = _SelectedDateState;
}
