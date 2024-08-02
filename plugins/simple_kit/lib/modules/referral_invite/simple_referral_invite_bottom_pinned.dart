import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import '../../simple_kit.dart';

class SReferralInviteBottomPinned extends StatefulWidget {
  const SReferralInviteBottomPinned({
    super.key,
    required this.onShare,
    required this.text,
  });

  final Function() onShare;
  final String text;

  @override
  State<SReferralInviteBottomPinned> createState() => _SReferralInviteBottomPinnedState();
}

class _SReferralInviteBottomPinnedState extends State<SReferralInviteBottomPinned> {
  bool canTapShare = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 42,
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
            if (canTapShare) {
              setState(() {
                canTapShare = false;
              });

              Timer(
                const Duration(seconds: 1),
                () {
                  setState(() {
                    canTapShare = true;
                  });
                },
              );
              widget.onShare();
            }
          },
          name: widget.text,
          active: true,
          icon: SShareIcon(
            color: SColorsLight().white,
          ),
        ),
      ),
    );
  }
}
