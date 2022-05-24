import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';

class DepositInfo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return Container(
      width: double.infinity,
      color: colors.blueLight,
      height: 88.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: Text(
            intl.depositInfo_text,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: sBodyText1Style,
          ),
        ),
      ),
    );
  }
}
