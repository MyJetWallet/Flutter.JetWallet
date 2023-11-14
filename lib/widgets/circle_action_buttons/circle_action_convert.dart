import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/modules/icons/24x24/public/transfer/simple_transfer_icon.dart';
import 'package:simple_kit/simple_kit.dart';

class CircleActionConvert extends StatelessWidget {
  const CircleActionConvert({
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
      defaultIcon: STransferIcon(
        color: colors.white,
      ),
      pressedIcon: STransferIcon(
        color: colors.white.withOpacity(0.7),
      ),
      onTap: onTap,
      isDisabled: isDisabled,
      name: intl.convert_convert,
    );
  }
}
