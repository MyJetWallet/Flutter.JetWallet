import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class CircleActionSettings extends StatelessWidget {
  const CircleActionSettings({
    super.key,
    required this.onTap,
    this.isDisabled = false,
  });

  final Function() onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SimpleCircleButton(
      defaultIcon: SCardSettingsIcon(
        color: colors.white,
      ),
      pressedIcon: SCardSettingsIcon(
        color: colors.white.withOpacity(0.7),
      ),
      onTap: onTap,
      isDisabled: isDisabled,
      name: intl.simple_card_settings,
    );
  }
}
