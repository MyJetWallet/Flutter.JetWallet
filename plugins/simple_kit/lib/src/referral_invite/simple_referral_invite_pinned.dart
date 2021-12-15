import 'package:flutter/material.dart';
import '../shared/constants.dart';

class SReferralInvitePinned extends StatelessWidget {
  const SReferralInvitePinned({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
