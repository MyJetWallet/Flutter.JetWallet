import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class DeepLinkService {



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
          referralCode: referralCode,
          referralLink: referralLink,
          onReadMoreTap: () {
            print('onReadMoreTap');
          },
        ),
      ],
    );
  }
}
