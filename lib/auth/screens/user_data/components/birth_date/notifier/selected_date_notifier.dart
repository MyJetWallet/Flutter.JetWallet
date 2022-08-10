import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../notifier/selected_date_notipod.dart';
import 'selected_date_state.dart';

class SelectedDateNotifier extends StateNotifier<SelectedDateState> {
  SelectedDateNotifier(this.read) : super(const SelectedDateState());
  final Reader read;
  static final _logger = Logger('SelectedDateNotifier');

  void updateDate(String date) {
    _logger.log(notifier, 'updateDate');
    state = state.copyWith(selectedDate: date);
    read(userDataNotipod.notifier).updateButtonActivity();
  }
}
