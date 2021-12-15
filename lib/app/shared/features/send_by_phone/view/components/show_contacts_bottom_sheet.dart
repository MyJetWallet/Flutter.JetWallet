import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

void showContactsBottomSheet(BuildContext context) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _ContactsPinned(),
    children: [],
  );
}

class _ContactsPinned extends StatelessWidget {
  const _ContactsPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SStandardField(labelText: 'Phone number');
  }
}
