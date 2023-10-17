import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/icons/24x24/public/copy/simple_copy_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/copy/simple_copy_pressed_icon.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

import '../../../core/l10n/i10n.dart';
import '../../../core/services/notification_service.dart';

class IBanItem extends StatelessObserverWidget {
  const IBanItem({
    super.key,
    required this.name,
    required this.text,
  });

  final String name;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    void onCopyAction() {
      sNotification.showError(
        intl.copy_message,
        id: 1,
        isError: false,
      );
    }

    return Column(
      children: [
        SPaddingH24(
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH21(),
                    Text(
                      name,
                      style: sCaptionTextStyle.copyWith(
                        color: colors.grey2,
                      ),
                    ),
                    Text(
                      text,
                      style: sSubtitle2Style.copyWith(
                        color: colors.black,
                      ),
                      maxLines: 2,
                    ),
                    const SpaceH21(),
                  ],
                ),
              ),
              const SpaceW16(),
              SIconButton(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: text,
                    ),
                  );

                  onCopyAction();
                },
                defaultIcon: const SCopyIcon(),
                pressedIcon: const SCopyPressedIcon(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
