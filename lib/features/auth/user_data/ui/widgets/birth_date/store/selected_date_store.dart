import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/auth/user_data/store/user_data_store.dart';
import 'package:jetwallet/utils/helpers/date_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';

part 'selected_date_store.g.dart';

class SelectedDateStore extends _SelectedDateStoreBase
    with _$SelectedDateStore {
  SelectedDateStore() : super();

  static SelectedDateStore of(BuildContext context) =>
      Provider.of<SelectedDateStore>(context, listen: false);
}

abstract class _SelectedDateStoreBase with Store {
  static final _logger = Logger('SelectedDateNotifier');

  final loader = StackLoaderStore();

  @observable
  String selectedDate = '';

  @action
  void updateDate(
    String date,
    UserDataStore userDateStore,
  ) {
    _logger.log(notifier, 'updateDate');

    if (isBirthDateValid(date)) {
      sNotification.showError(
        intl.user_data_date_of_birth_is_not_valid,
        id: 1,
      );
    } else {
      selectedDate = date;

      userDateStore.updateButtonActivity();
    }
  }
}
