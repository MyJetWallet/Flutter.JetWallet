import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/providers/service_providers.dart';

class SendInfoText extends HookWidget {
  const SendInfoText({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return GestureDetector(
      onTap: onTap,
      child: SPaddingH24(
        child: Row(
          children: [
            SInfoIcon(
              color: colors.blue,
            ),
            const SpaceW10(),
            Baseline(
              baseline: 16.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                intl.sendInfoText_text,
                style: sCaptionTextStyle.copyWith(
                  color: colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
