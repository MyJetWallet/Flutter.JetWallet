import 'package:flutter/material.dart';
import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SReferralInviteBottomPinned extends StatelessWidget {
  const SReferralInviteBottomPinned({
    Key? key,
    required this.onShare,
  }) : super(key: key);

  final Function() onShare;

  @override
  Widget build(BuildContext context) {
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
          onTap: onShare,
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
