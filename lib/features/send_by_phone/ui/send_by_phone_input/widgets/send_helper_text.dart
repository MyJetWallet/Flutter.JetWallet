import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class SendHelperText extends StatelessObserverWidget {
  const SendHelperText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPaddingH24(
      child: Baseline(
        baseline: 32.0,
        baselineType: TextBaseline.alphabetic,
        child: Text(
          intl.sendHelperText_text,
          maxLines: 2,
          style: sCaptionTextStyle.copyWith(
            color: colors.grey1,
          ),
        ),
      ),
    );
  }
}
