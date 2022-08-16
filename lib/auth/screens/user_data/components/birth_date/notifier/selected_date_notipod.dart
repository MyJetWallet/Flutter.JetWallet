import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'selected_date_notifier.dart';
import 'selected_date_state.dart';

final selectedDateNotipod =
    StateNotifierProvider.autoDispose<SelectedDateNotifier, SelectedDateState>(
        (ref) {
  return SelectedDateNotifier(ref.read);
});
