import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

void showContactsBottomSheet(BuildContext context) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _ContactsPinned(),
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      const SContactItem(
        name: 'Danil Shcherbak',
        phone: '+380 (50) 333 44 55',
      ),
      const SContactItem(
        name: 'Danil Shcherbak',
        phone: '+380 (50) 333 44 55',
      ),
      const SContactItem(
        name: 'Danil Shcherbak',
        phone: '+380 (50) 333 44 55',
      ),
      const SContactItem(
        name: 'Danil Shcherbak',
        phone: '+380 (50) 333 44 55',
      ),
      const SContactItem(
        name: 'Danil Shcherbak',
        phone: '+380 (50) 333 44 55',
      ),
      const SpaceH24(),
    ],
  );
}

class _ContactsPinned extends StatelessWidget {
  const _ContactsPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SStandardField(
      labelText: 'Phone number',
    );
  }
}
