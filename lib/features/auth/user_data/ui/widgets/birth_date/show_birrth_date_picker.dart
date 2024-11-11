import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/auth/user_data/store/user_data_store.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/birth_date/store/selected_date_store.dart';
import 'package:jetwallet/utils/helpers/date_helper.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

void showBirthDatePicker(
  BuildContext context,
  SelectedDateStore selectDateStore,
  UserDataStore userDateStore,
) {
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    pinned: const _Header(),
    enableDrag: false,
    children: [
      _SDatePicker(
        store: selectDateStore,
        userDateStore: userDateStore,
      ),
      const SpaceH42(),
    ],
  );
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return ActionBottomSheetHeader(
      name: intl.user_data_bottom_sheet_date_of_birth,
      removePadding: true,
    );
  }
}

class _SDatePicker extends StatelessObserverWidget {
  const _SDatePicker({
    required this.store,
    required this.userDateStore,
  });

  final SelectedDateStore store;
  final UserDataStore userDateStore;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    var date = formatDateForUi(getMinBirthDate());

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SPaddingH24(
              child: Column(
                children: [
                  const SpaceH4(),
                  Container(
                    height: 1,
                    color: colors.grey4,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    height: 1,
                    color: colors.grey4,
                  ),
                ],
              ),
            ),
            DatePickerWidget(
              initialDate: getDateForPicker(),
              dateFormat: 'd/MMM/yyyy',
              pickerTheme: DateTimePickerTheme(
                dividerColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                pickerHeight: 280.0,
                itemHeight: 64,
                itemTextStyle: STStyles.subtitle1.copyWith(
                  color: colors.black,
                ),
              ),
              onChange: (value, v) {
                date = formatDateForUi(value);
              },
              locale: intl.localeName == 'es'
                  ? DateTimePickerLocale.es
                  : intl.localeName == 'pl'
                      ? DateTimePickerLocale.pl
                      : DateTimePickerLocale.en_us,
            ),
          ],
        ),
        SPaddingH24(
          child: SButton.blue(
            text: intl.user_data_bottom_sheet_confirm,
            callback: () {
              store.updateDate(date, userDateStore);
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
