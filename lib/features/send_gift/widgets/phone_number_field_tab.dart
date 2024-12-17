import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/features/send_gift/widgets/show_country_phone_number_picker.dart';
import 'package:simple_kit/modules/icons/24x24/public/erase/simple_erase_icon.dart';

import '../../../core/l10n/i10n.dart';
import '../../set_phone_number/store/set_phone_number_store.dart';
import '../store/receiver_datails_store.dart';

class PhoneNumberFieldTab extends StatelessWidget {
  PhoneNumberFieldTab({super.key, required this.store});

  final ReceiverDatailsStore store;
  final SetPhoneNumberStore phoneStore = SetPhoneNumberStore();

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: colors.white,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 24,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: colors.gray4,
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    showGiftCountryPhoneNumberPicker(context, phoneStore);
                  },
                  child: SizedBox(
                    width: 76,
                    child: AbsorbPointer(
                      child: SInput(
                        label: intl.setPhoneNumber_code,
                        isDisabled: true,
                        focusNode: phoneStore.dialFocusNode,
                        controller: phoneStore.dialCodeController,
                      ),
                    ),
                  ),
                ),
              ),
              Observer(
                builder: (context) {
                  return Expanded(
                    child: SInput(
                      label: intl.setPhoneNumber_phoneNumber,
                      focusNode: phoneStore.focusNode,
                      autofillHints: const [
                        AutofillHints.telephoneNumber,
                      ],
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      onChanged: (String phone) {
                        phoneStore.updatePhoneNumber(phone);
                        phoneStore.phoneNumber();
                        store.onChangedPhone(
                          phoneStore.phoneNumberController.text,
                          phoneStore.dialCodeController.text,
                        );
                      },
                      controller: phoneStore.phoneNumberController,
                      suffixIcon: phoneStore.phoneInput.isNotEmpty
                          ? SafeGesture(
                              onTap: () => phoneStore.clearPhone(),
                              child: const SEraseIcon(),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
