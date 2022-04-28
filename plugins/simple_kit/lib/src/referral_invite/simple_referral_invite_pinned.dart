import 'package:flutter/material.dart';

import '../../simple_kit.dart';

class SReferralInvitePinned extends StatelessWidget {
  const SReferralInvitePinned({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            image: DecorationImage(
              image: AssetImage(
                referralInviteFriendsAsset,
                package: 'simple_kit',
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
