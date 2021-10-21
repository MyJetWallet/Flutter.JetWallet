import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import 'search_state.dart';

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier()
      : super(
          SearchState(
            searchController: TextEditingController(),
          ),
        );

  static final _logger = Logger('SearchNotifier');

  void updateSearch(String search) {
    if (search != state.search) {
      _logger.log(notifier, 'updateSearch');

      state = state.copyWith(search: search);
    }
  }
}
