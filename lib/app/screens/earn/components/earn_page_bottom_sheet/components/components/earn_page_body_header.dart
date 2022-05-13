import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/service_providers.dart';

class EarnPageBodyHeader extends HookWidget {
  const EarnPageBodyHeader({
    Key? key,
    required this.colors,
  }) : super(key: key);

  final SimpleColors colors;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);

    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${intl.earn_program}\n',
                style: sTextH2Style.copyWith(
                  color: colors.green,
                ),
              ),
              TextSpan(
                text: '${intl.earn_sheet_subtitle}',
                style: sTextH2Style.copyWith(
                  color: colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
