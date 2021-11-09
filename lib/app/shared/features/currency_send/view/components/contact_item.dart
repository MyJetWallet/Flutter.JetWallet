import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import '../../notifier/send_input_phone_number/send_input_phone_number_notipod.dart';
import '../screens/send_input_amount.dart';

class ContactItem extends HookWidget {
  const ContactItem({
    Key? key,
    required this.contact,
    required this.withdrawal,
  }) : super(key: key);

  final Contact contact;
  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final inputPhoneNumberN = useProvider(sendInputPhoneNumberNotipod.notifier);

    return InkWell(
      onTap: () {
        inputPhoneNumberN.updatePhoneNumber(contact.phones!.first.value);
        inputPhoneNumberN.updateName(contact.displayName);
        navigatorPush(
          context,
          SendInputAmount(withdrawal: withdrawal),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            if (contact.avatar != null && contact.avatar!.isNotEmpty)
              CircleAvatar(
                backgroundImage: MemoryImage(contact.avatar!),
                radius: 18.r,
              )
            else
              CircleAvatar(
                radius: 18.r,
                child: Text(
                  contact.initials(),
                ),
              ),
            const SpaceW10(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.displayName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    contact.phones!.first.value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
