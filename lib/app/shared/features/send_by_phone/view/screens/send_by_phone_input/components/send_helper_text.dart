import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class SendHelperText extends HookWidget {
  const SendHelperText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SPaddingH24(
      child: Baseline(
        baseline: 32.0,
        baselineType: TextBaseline.alphabetic,
        child: Text(
          'Start typing phone number or name from your phonebook',
          maxLines: 2,
          style: sCaptionTextStyle.copyWith(
            color: colors.grey1,
          ),
        ),
      ),
    );
  }
}
