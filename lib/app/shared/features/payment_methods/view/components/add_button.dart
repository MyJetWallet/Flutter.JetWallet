import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';

class AddButton extends HookWidget {
  const AddButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return SSecondaryButton1(
      active: true,
      name: intl.addButton_addBankCard,
      icon: Container(
        margin: const EdgeInsets.only(
          top: 32,
        ),
        child: SActionBuyIcon(
          color: colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
