import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class DeepLinkService {

  void deepLinkCheck({
    required String deepLink,
    required BuildContext context,
    required String referralLink,
    required String referralCode,
  }) {
    if (deepLink.contains('jw_command')) {
      if (deepLink.contains('InviteFriend')) {
        showBasicModalBottomSheet(
          context,
          referralLink,
          referralCode,
        );
      }
    }
  }

  void showBasicModalBottomSheet(
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
          onReadMoreTap: () {
            print('onReadMoreTap');
          },
        ),
      ],
    );
  }
}
