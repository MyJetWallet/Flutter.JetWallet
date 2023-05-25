import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../simple_kit.dart';
import 'components/simple_conditions_referral_invite.dart';

class SReferralInviteBody extends StatelessWidget {
  const SReferralInviteBody({
    Key? key,
    required this.logoSize,
    required this.primaryText,
    required this.onReadMoreTap,
    required this.showReadMore,
    required this.conditions,
    required this.referralLink,
    required this.copiedText,
    required this.referralText,
  }) : super(key: key);

  final double logoSize;
  final String primaryText;
  final void Function() onReadMoreTap;
  final bool showReadMore;
  final List<String> conditions;
  final String referralLink;
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
        const SpaceH16(),
        const SPaddingH24(
          child: SDivider(),
        ),
        const SpaceH25(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              padding: EdgeInsets.zero,
              data: referralLink,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
              embeddedImage: const AssetImage(
                sQrLogo,
                package: 'simple_kit',
              ),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(logoSize, logoSize),
              ),
              size: 200.0,
            ),
          ],
        ),
        const SpaceH25(),
      ],
    );
  }
}
