import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class HistoryCopyIcon extends StatelessWidget {
  const HistoryCopyIcon(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

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
        defaultIcon: Assets.svg.medium.copy.simpleSvg(
          width: 20,
          color: colors.gray8,
        ),
        pressedIcon: Assets.svg.medium.copy.simpleSvg(
          width: 20,
          color: colors.gray8,
        ),
      ),
    );
  }
}
