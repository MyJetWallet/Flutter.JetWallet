import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/date_helper.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../notifier/selected_date_notipod.dart';
import 'selected_date_state.dart';

class SelectedDateNotifier extends StateNotifier<SelectedDateState> {
  SelectedDateNotifier(this.read) : super(const SelectedDateState());
  final Reader read;
  static final _logger = Logger('SelectedDateNotifier');

  void updateDate(String date) {
    _logger.log(notifier, 'updateDate');
    if (isBirthDateValid(date)) {
      final intl = read(intlPod);
      read(sNotificationNotipod.notifier).showError(
        intl.user_data_date_of_birth_is_not_valid,
        duration: 4,
        id: 1,
      );
    } else {
      state = state.copyWith(selectedDate: date);
      read(userDataNotipod.notifier).updateButtonActivity();
    }
  }
}
