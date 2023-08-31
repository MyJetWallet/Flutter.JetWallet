import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/l10n/i10n.dart';
import '../../../../utils/constants.dart';

class RewardNotificationBox extends StatelessWidget {
  const RewardNotificationBox({
    super.key,
    required this.isUnread,
    required this.child,
  });

  final bool isUnread;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isUnread ? 17 : 24),
      child: Container(
        decoration: isUnread
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  width: 3.0,
                  color: colors.blue,
                ),
              )
            : null,
        child: Padding(
          padding: EdgeInsets.all(isUnread ? 4 : 0),
          child: Stack(
            children: [
              child,
              if (isUnread)
                Positioned(
                  top: 9,
                  left: 20,
                  child: Row(
                    children: [
                      Image.asset(
                        fireRewardAsset,
                        height: 16,
                        width: 9,
                      ),
                      const SpaceW6(),
                      Text(
                        intl.rewards_new,
                        style: sBodyText2Style.copyWith(
                          color: colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
