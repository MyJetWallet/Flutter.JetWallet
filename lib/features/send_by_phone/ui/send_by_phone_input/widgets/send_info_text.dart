import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class SendInfoText extends StatelessObserverWidget {
  const SendInfoText({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

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
            ),
          ],
        ),
      ),
    );
  }
}
