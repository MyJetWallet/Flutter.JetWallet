import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class AddButton extends StatelessObserverWidget {
  const AddButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

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
