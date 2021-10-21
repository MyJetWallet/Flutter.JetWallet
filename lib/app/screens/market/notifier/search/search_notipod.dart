import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'search_notifier.dart';
import 'search_state.dart';

final searchNotipod =
    StateNotifierProvider.autoDispose<SearchNotifier, SearchState>(
  (ref) {
    return SearchNotifier();
  },
);
