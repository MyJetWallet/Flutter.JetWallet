import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import '../../notifier/send_input_phone_number/send_input_phone_number_notipod.dart';
import '../components/contacts_list.dart';
import 'send_input_amount.dart';

class SendInputPhone extends StatefulHookWidget {
  const SendInputPhone({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  State<StatefulWidget> createState() => _SendInputPhoneState();
}

class _SendInputPhoneState extends State<SendInputPhone> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final inputPhoneNumberN = context.read(
        sendInputPhoneNumberNotipod.notifier,
      );
      final permissionAsked = await inputPhoneNumberN.checkPermissionAsked();

      if (!permissionAsked) {
        await inputPhoneNumberN.setPermissionAsked();
        _showContactsDescriptionDialog();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currency = widget.withdrawal.currency;
    final inputPhoneNumberN = useProvider(sendInputPhoneNumberNotipod.notifier);
    final state = useProvider(sendInputPhoneNumberNotipod);

    return PageFrame(
      header: '${widget.withdrawal.dictionary.verb} '
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
              inputPhoneNumberN.updatePhoneNumber(number.phoneNumber);
            },
            onInputValidated: (valid) {
              inputPhoneNumberN.updateValid(valid: valid);
            },
          ),
          const SpaceH10(),
          Text(
            'Start typing phone number or name from your address book',
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
          const SpaceH10(),
          Row(
            children: [
              InkWell(
                onTap: () => inputPhoneNumberN.askContactsPermission(
                  _showContactsSearchBottomSheet,
                ),
                child: Text(
                  'I want to use my phonebook',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SpaceW4(),
              InkWell(
                onTap: _showContactsDescriptionDialog,
                child: Icon(
                  Icons.info_outline,
                  size: 16.r,
                ),
              ),
            ],
          ),
          const Spacer(),
          AppButtonSolid(
            name: 'Continue',
            active: state.valid,
            onTap: () async {
              navigatorPush(
                context,
                SendInputAmount(withdrawal: widget.withdrawal),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showContactsDescriptionDialog() {
    final notifier = context.read(sendInputPhoneNumberNotipod.notifier);

    showDialog(
      context: context,
      builder: (builderContext) {
        return CupertinoAlertDialog(
          title: const Text(
            'Use Address Book?',
          ),
          content: const Text(
            'Inviting friends is simple when choosing them from the address '
            "book on you phone.\n\nOtherwise, you'll have to type contact "
            'info individually.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(builderContext).pop();
                notifier.askContactsPermission(_showContactsSearchBottomSheet);
              },
              child: const Text(
                'Use Address Book',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(builderContext);
              },
              child: const Text(
                "I'll Enter Contact Info",
              ),
            ),
          ],
        );
      },
    );
  }

  void _showContactsSearchBottomSheet() {
    final notifier = context.read(sendInputPhoneNumberNotipod.notifier);

    showBasicBottomSheet(
      scrollable: true,
      minHeight: 0.7.sh,
      pinned: TextFormField(
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28.sp,
        ),
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: 'Type or search',
          floatingLabelStyle: TextStyle(
            fontSize: 12.sp,
          ),
        ),
        onChanged: (value) {
          notifier.updateSearch(value);
        },
      ),
      children: [
        ContactsList(
          withdrawal: widget.withdrawal,
        ),
      ],
      context: context,
    );
  }
}
