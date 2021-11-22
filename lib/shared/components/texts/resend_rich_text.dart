import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../providers/service_providers.dart';

class ResendRichText extends HookWidget {
  const ResendRichText({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Center(
      child: Column(
        children: <Widget>[
          Text(
            '${intl.didntReceiveTheCode} ',
            style: sCaptionTextStyle.copyWith(
              color: SColorsLight().grey2,
            ),
          ),
          const SpaceH10(),
          STextButton1(
            active: true,
            name: intl.resend,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
