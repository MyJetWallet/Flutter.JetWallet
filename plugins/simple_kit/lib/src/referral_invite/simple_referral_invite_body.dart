import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../simple_kit.dart';
import 'components/simple_conditions_referral_invite.dart';

class SReferralInviteBody extends StatelessWidget {
  const SReferralInviteBody({
    Key? key,
    required this.primaryText,
    required this.onReadMoreTap,
    required this.showReadMore,
    required this.conditions,
    required this.referralLink,
    required this.readMoreText,
    required this.copiedText,
    required this.referralText,
  }) : super(key: key);

  final String primaryText;
  final void Function() onReadMoreTap;
  final bool showReadMore;
  final List<String> conditions;
  final String referralLink;
  final String readMoreText;
  final String copiedText;
  final String referralText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH24(),
        for (final condition in conditions) ...[
          SimpleConditionsReferralInvite(
            conditionText: condition,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          const SpaceH16(),
        ],
        const SpaceH24(),
        const SPaddingH24(
          child: SDivider(),
        ),
        const SpaceH20(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              padding: EdgeInsets.zero,
              data: referralLink,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
              embeddedImage: const AssetImage(
                sQrLogo,
                package: 'simple_kit',
              ),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(71.0, 71.0),
              ),
              size: 200.0,
            ),
          ],
        ),
        const SpaceH20(),
        SAddressFieldWithCopy(
          afterCopyText: copiedText,
          value: referralLink,
          header: referralText,
        ),
        const SpaceH20(),
      ],
    );
  }
}
