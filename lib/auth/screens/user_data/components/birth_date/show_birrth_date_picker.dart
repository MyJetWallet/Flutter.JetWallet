import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../app/shared/features/actions/shared/components/action_bottom_sheet_header.dart';
import '../../../../../shared/helpers/date_helper.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'notifier/selected_date_notipod.dart';

void showBirthDatePicker(BuildContext context) {
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    pinned: const _Header(),
    children: [
      const _SDatePicker(),
      const SpaceH24(),
    ],
  );
}

class _Header extends HookWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionBottomSheetHeader(
      name: useProvider(intlPod).user_data_bottom_sheet_date_of_birth,
      removePadding: true,
    );
  }
}

class _SDatePicker extends HookWidget {
  const _SDatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final selectedDateN = useProvider(selectedDateNotipod.notifier);
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
                itemTextStyle: sSubtitle2Style.copyWith(
                  color: colors.black,
                ),
              ),
              onChange: (value, v) {
                date = formatDateForUi(value);
              },
            ),
          ],
        ),
        SPaddingH24(
          child: SPrimaryButton4(
            name: intl.user_data_bottom_sheet_confirm,
            onTap: () {
              selectedDateN.updateDate(date);
              Navigator.of(context).pop();
            },
            active: true,
          ),
        ),
      ],
    );
  }
}
