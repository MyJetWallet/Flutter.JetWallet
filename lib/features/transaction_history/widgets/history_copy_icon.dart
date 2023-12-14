import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/icons/24x24/public/copy/simple_copy_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/copy/simple_copy_pressed_icon.dart';

class HistoryCopyIcon extends StatelessWidget {
  const HistoryCopyIcon(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: SIconButton(
        onTap: () {
          Clipboard.setData(
            ClipboardData(
              text: text,
            ),
          );

          sNotification.showError(
            intl.copy_message,
            id: 1,
            isError: false,
          );
        },
        defaultIcon: const SCopyIcon(),
        pressedIcon: const SCopyPressedIcon(),
      ),
    );
  }
}
