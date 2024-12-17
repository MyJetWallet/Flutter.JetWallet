import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';

class HistoryCopyIcon extends StatelessWidget {
  const HistoryCopyIcon(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SizedBox(
      width: 20,
      height: 20,
      child: SafeGesture(
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
        child: Assets.svg.medium.copy.simpleSvg(
          width: 20,
          color: colors.gray8,
        ),
      ),
    );
  }
}
