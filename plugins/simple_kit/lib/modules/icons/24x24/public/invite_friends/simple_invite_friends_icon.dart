import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/invite_friends/simple_light_invite_friends_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SInviteFriendsIcon extends StatelessObserverWidget {
  const SInviteFriendsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightInviteFriendsIcon()
        : const SimpleLightInviteFriendsIcon();
  }
}
