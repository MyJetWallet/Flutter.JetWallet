import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/send_gift/widgets/show_country_phone_number_picker.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/fields/standard_field/public/simple_standard_field.dart';
import 'package:simple_kit/modules/icons/24x24/public/erase/simple_erase_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/erase/simple_erase_pressed_icon.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';

import '../../../core/l10n/i10n.dart';

import '../../set_phone_number/store/set_phone_number_store.dart';
import '../store/receiver_datails_store.dart';

class PhoneNumberFieldTab extends StatelessWidget {
  PhoneNumberFieldTab({super.key, required this.store});

  final ReceiverDatailsStore store;
  final SetPhoneNumberStore phoneStore = SetPhoneNumberStore();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

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
                      color: colors.grey4,
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
                      child: SStandardField(
                        labelText: intl.setPhoneNumber_code,
                        readOnly: true,
                        hideClearButton: true,
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
                    child: SPaddingH24(
                      child: SStandardField(
                        labelText: intl.setPhoneNumber_phoneNumber,
                        focusNode: phoneStore.focusNode,
                        autofillHints: const [
                          AutofillHints.telephoneNumber,
                        ],
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        onChanged: (String phone) {
                          phoneStore.updatePhoneNumber(phone);
                          phoneStore.phoneNumber();
                          store.onChangedPhone(phoneStore.phoneNumber());
                        },
                        controller: phoneStore.phoneNumberController,
                        suffixIcons: phoneStore.phoneInput.isNotEmpty
                            ? [
                                SIconButton(
                                  onTap: () => phoneStore.clearPhone(),
                                  defaultIcon: const SEraseIcon(),
                                  pressedIcon: const SErasePressedIcon(),
                                ),
                              ]
                            : null,
                      ),
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
