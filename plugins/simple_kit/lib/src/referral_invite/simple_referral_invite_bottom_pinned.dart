import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SReferralInviteBottomPinned extends StatefulHookWidget {
  const SReferralInviteBottomPinned({
    Key? key,
    required this.onShare,
  }) : super(key: key);

  final Function() onShare;

  @override
  State<SReferralInviteBottomPinned> createState() => _SReferralInviteBottomPinnedState();
}

class _SReferralInviteBottomPinnedState extends State<SReferralInviteBottomPinned>
  with WidgetsBindingObserver {
  bool canTapShare = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        canTapShare = true;
      });
    }
  }

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
          onTap: () {
            if (canTapShare) {
              setState(() {
                canTapShare = false;
              });
              Timer(const Duration(seconds: 1), () => setState(() {
                canTapShare = true;
              }),);
              widget.onShare();
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
