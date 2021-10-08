import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/notifiers/enter_phone_notifier/enter_phone_notipod.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import 'send_input_amount.dart';

class SendInputPhone extends HookWidget {
  const SendInputPhone({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final enterPhone = useProvider(enterPhoneNotipod);
    final enterPhoneN = useProvider(enterPhoneNotipod.notifier);
    final currency = withdrawal.currency;

    return PageFrame(
      header: '${withdrawal.dictionary.verb} '
          '${currency.description} by phone',
      onBackButton: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH40(),
          Text(
            'You send to',
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
          InternationalPhoneNumberInput(
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.DIALOG,
            ),
            ignoreBlank: true,
            autoValidateMode: AutovalidateMode.always,
            onInputChanged: (number) {
              enterPhoneN.updatePhoneNumber(number.phoneNumber);
            },
            onInputValidated: (valid) {
              enterPhoneN.updateValid(valid: valid);
            },
          ),
          const SpaceH10(),
          Text(
            'Start typing phone number or name from your address book',
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
          const Spacer(),
          AppButtonSolid(
            name: 'Continue',
            active: enterPhone.valid,
            onTap: () async {
              navigatorPush(
                context,
                SendInputAmount(
                  withdrawal: withdrawal,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
