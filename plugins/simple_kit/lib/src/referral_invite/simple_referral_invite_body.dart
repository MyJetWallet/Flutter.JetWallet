import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../simple_kit.dart';
import 'components/simple_conditions_referral_invite.dart';

class SReferralInviteBody extends StatelessWidget {
  const SReferralInviteBody({
    Key? key,
    required this.primaryText,
    required this.qrCodeLink,
    required this.referralLink,
  }) : super(key: key);

  final String primaryText;
  final String qrCodeLink;
  final String referralLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SPaddingH24(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 203.0,
                child: Baseline(
                  baseline: 64.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    primaryText,
                    maxLines: 3,
                    style: sTextH2Style,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Todo: navigate to read more screen
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Baseline(
                    baseline: 104,
                    baselineType: TextBaseline.alphabetic,
                    child: SimpleAccountTermButton(
                      name: 'Read more',
                      onTap: () {
                        // Todo: navigate to read more screen
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SpaceH40(),
        const SimpleConditionsReferralInvite(
          conditionText: 'Get \$5 for account verification',
        ),
        const SpaceH16(),
        const SimpleConditionsReferralInvite(
          conditionText: 'Get \$5 after making first deposit',
        ),
        const SpaceH16(),
        const SimpleConditionsReferralInvite(
          conditionText: 'Get \$5 after trading \$100',
        ),
        const SpaceH16(),
        const SimpleConditionsReferralInvite(
          conditionText: 'Earn 20% trading commission from all\nfriends',
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        const SpaceH40(),
        const SPaddingH24(
          child: SDivider(),
        ),
        const SpaceH20(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              padding: EdgeInsets.zero,
              data: qrCodeLink,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
              embeddedImage: const AssetImage(
                sQrLogo,
                package: 'simple_kit',
              ),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(90.0, 90.0),
              ),
              size: 200.0,
            ),
          ],
        ),
        const SpaceH20(),
        SAddressFieldWithCopy(
          afterCopyText: 'Referral link copied',
          value: referralLink,
          header: 'Referral link',
        ),
        const SpaceH20(),
      ],
    );
  }
}
