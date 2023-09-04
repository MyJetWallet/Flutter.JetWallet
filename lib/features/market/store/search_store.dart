import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';

part 'search_store.g.dart';

@lazySingleton
class SearchStore = _SearchStoreBase with _$SearchStore;

abstract class _SearchStoreBase with Store {
  static final _logger = Logger('SearchStore');

  @observable
  String search = '';

  @observable
  TextEditingController searchController = TextEditingController();

  @action
  void updateSearch(String newSearch) {
    if (newSearch != search) {
      _logger.log(notifier, 'updateSearch');

      search = newSearch;
    }
  }

  @action
  void dispose() {
    searchController.dispose();
  }
}
