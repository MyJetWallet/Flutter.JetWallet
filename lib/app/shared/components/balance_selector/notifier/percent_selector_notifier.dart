import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/selected_percent.dart';

class PercentSelectorNotifier extends StateNotifier<SelectedPercent> {
  PercentSelectorNotifier() : super(SelectedPercent.none);

  SelectedPercent update(SelectedPercent selected) {
    if (selected == state) {
      return state = SelectedPercent.none;
    } else {
      return state = selected;
    }
  }
}
