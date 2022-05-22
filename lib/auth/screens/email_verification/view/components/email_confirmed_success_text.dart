import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/providers/service_providers.dart';

class EmailConfirmedSuccessText extends HookWidget {
  const EmailConfirmedSuccessText({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);

    return Column(
      children: [
        Row(), // to expand Column in the cross axis
        Baseline(
          baseline: 31.4,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            intl.emailConfirmedSuccessText_yourEmailAddress,
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
          ),
        ),
        Text(
          email,
          style: sBodyText1Style.copyWith(
            color: colors.black,
          ),
        ),
        Text(
          intl.emailConfirmedSuccessText_isConfirmed,
          style: sBodyText1Style.copyWith(
            color: colors.grey1,
          ),
        ),
      ],
    );
  }
}
