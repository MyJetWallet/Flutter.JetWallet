import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightInviteFriendsIcon extends StatelessWidget {
  const SimpleLightInviteFriendsIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName:
          'assets/icons/light/24x24/profile/invite_friends/invite_icon.svg',
      color: color,
    );
  }
}
