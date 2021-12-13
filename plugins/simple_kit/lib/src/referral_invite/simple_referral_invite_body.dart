import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../simple_kit.dart';
import '../shared/constants.dart';

class SReferralInviteBody extends StatelessWidget {
  const SReferralInviteBody({
    Key? key,
    this.onReadMoreTap,
    required this.primaryText,
    required this.referralCode,
  }) : super(key: key);

  final String primaryText;
  final String referralCode;
  final Function()? onReadMoreTap;

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
              Container(
                alignment: Alignment.bottomCenter,
                child: Baseline(
                  baseline: 104,
                  baselineType: TextBaseline.alphabetic,
                  child: SimpleAccountTermButton(
                    name: 'Read more',
                    onTap: () => onReadMoreTap?.call(),
                  ),
                ),
              ),
            ],
          ),
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
              data: referralCode,
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
        const SAddressFieldWithCopy(
          afterCopyText: 'Referral link copied',
          value: 'http://simple.net/?Ref=7455258',
          header: 'Referral link',
        ),
        const SDivider(),
        const SpaceH24(),
        SPaddingH24(
          child: SPrimaryButton2(
            onTap: () {},
            name: 'Share',
            active: true,
            icon: SShareIcon(
              color: SColorsLight().white,
            ),
          ),
        ),
        const SpaceH24(),
      ],
    );
  }
}
