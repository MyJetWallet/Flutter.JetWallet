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
            const SizedBox(
              height: 0,
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
                      color: Colors.grey,
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
