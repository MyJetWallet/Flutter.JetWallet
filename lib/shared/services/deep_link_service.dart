import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../notifiers/user_info_notifier/user_info_notipod.dart';

const _jwCommand = 'InviteFriend';

class DeepLinkService {
  DeepLinkService(this.read);

  final Reader read;

  void handle(Uri uri) {
    if (uri.queryParameters['link']!.contains(_jwCommand)) {
      handleInviteFriends();
    }
  }

  void handleInviteFriends() {
    final context =  read(sNavigatorKeyPod).currentContext!;
    final userInfo = read(userInfoNotipod);

    _showBasicModalBottomSheet(
      context,
      userInfo.referralLink!,
      userInfo.referralCode!,
    );
  }

  void _showBasicModalBottomSheet(
    BuildContext context,
    String referralLink,
    String referralCode,
  ) {
    sShowBasicModalBottomSheet(
      context: context,
      removeBottomHeaderPadding: true,
      removeBottomSheetBar: true,
      removeTopHeaderPadding: true,
      horizontalPinnedPadding: 0,
      scrollable: true,
      pinned: const SReferralInvitePinned(),
      children: [
        SReferralInviteBody(
          primaryText: 'Invite friends and get \$10',
          qrCodeLink: referralLink,
          referralLink: referralLink,
          onReadMoreTap: () {},
        ),
      ],
    );
  }
}
