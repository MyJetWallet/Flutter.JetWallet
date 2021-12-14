import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

void showContactsBottomSheet(BuildContext context) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const SBottomSheetHeader(
      name: 'Contacts',
    ),
    children: [],
  );
}
