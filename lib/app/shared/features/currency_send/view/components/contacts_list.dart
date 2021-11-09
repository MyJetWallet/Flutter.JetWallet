import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../currency_withdraw/model/withdrawal_model.dart';
import '../../notifier/send_input_phone_number/send_input_phone_number_notipod.dart';
import 'contact_item.dart';

class ContactsList extends HookWidget {
  const ContactsList({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final contacts =
        useProvider(sendInputPhoneNumberNotipod).filteredContacts();

    if (contacts.isNotEmpty) {
      return ListView.separated(
        itemCount: contacts.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ContactItem(
            contact: contacts[index],
            withdrawal: withdrawal,
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      );
    } else {
      return Container();
    }
  }
}
