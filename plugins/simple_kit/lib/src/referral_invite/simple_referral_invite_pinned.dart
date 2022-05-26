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
    return Column(
      children: [
        Stack(
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
            Positioned(
              top: 33.0,
              right: 26.0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const SEraseMarketIcon(),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              top: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35.0,
                    height: 4.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SpaceH30(),
        if (child != null) child!,
      ],
    );
  }
}
