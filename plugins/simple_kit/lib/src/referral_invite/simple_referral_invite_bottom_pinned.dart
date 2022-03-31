import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SReferralInviteBottomPinned extends HookWidget {
  const SReferralInviteBottomPinned({
    Key? key,
    required this.onShare,
  }) : super(key: key);

  final Function() onShare;

  @override
  Widget build(BuildContext context) {
    final canTapShare = useState(true);

    return Container(
      padding: const EdgeInsets.only(
        bottom: 24,
        top: 24,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: SColorsLight().grey4,
          ),
        ),
      ),
      child: SPaddingH24(
        child: SPrimaryButton2(
          onTap: () {
            if (canTapShare.value) {
              canTapShare.value = false;
              Timer(
                  const Duration(seconds: 1), () => canTapShare.value = true,
              );
              onShare();
            }
          },
          name: 'Share',
          active: true,
          icon: SShareIcon(
            color: SColorsLight().white,
          ),
        ),
      ),
    );
  }
}
