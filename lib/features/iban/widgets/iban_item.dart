import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:simple_kit/modules/icons/24x24/public/copy/simple_copy_icon.dart';

import '../../../core/l10n/i10n.dart';
import '../../../core/services/notification_service.dart';

void onCopyAction({VoidCallback? afterCopy}) {
  sNotification.showError(
    intl.copy_message,
    id: 1,
    isError: false,
  );

  if (afterCopy != null) {
    afterCopy();
  }
}

class IBanItem extends StatelessObserverWidget {
  const IBanItem({
    super.key,
    required this.name,
    required this.text,
    this.afterCopy,
  });

  final String name;
  final String text;
  final VoidCallback? afterCopy;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

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
                      style: STStyles.captionMedium.copyWith(
                        color: colors.gray10,
                      ),
                    ),
                    Text(
                      text,
                      style: STStyles.subtitle1,
                      maxLines: 2,
                    ),
                    const SpaceH21(),
                  ],
                ),
              ),
              const SpaceW16(),
              SafeGesture(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: text,
                    ),
                  );

                  onCopyAction(afterCopy: afterCopy);
                },
                child: const SCopyIcon(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
