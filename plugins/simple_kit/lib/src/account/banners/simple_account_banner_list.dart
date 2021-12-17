import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SimpleAccountBannerList extends StatelessWidget {
  const SimpleAccountBannerList({
    Key? key,
    this.onTwoFaBannerTap,
    this.onChatBannerTap,
    required this.twoFaEnabled,
    required this.kycPassed,
    required this.phoneVerified,
  }) : super(key: key);

  final Function()? onTwoFaBannerTap;
  final Function()? onChatBannerTap;
  final bool twoFaEnabled;
  final bool kycPassed;
  final bool phoneVerified;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: setSizedBoxHeight(
        kycPassed: kycPassed,
        phoneVerified: phoneVerified,
        twoFaEnabled: twoFaEnabled,
      ),
      child: Column(
        children: [
          if (!kycPassed || !phoneVerified || !twoFaEnabled)
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SpaceW24(),
                  const SpaceW8(),
                  if (!kycPassed)
                    SimpleAccountBanner(
                      onTap: () {},
                      color: SColorsLight().violet,
                      header: 'Verify your profile',
                      description: 'In accordance with KYC and AML Policy, '
                          'you are required to pass the '
                          'verification process.',
                    ),
                  if (!phoneVerified)
                    SimpleAccountBanner(
                      onTap: () {},
                      color: SColorsLight().greenLight,
                      header: 'Verifying now',
                      description:
                          'You’ll be notified after we’ve completed the '
                              'process. '
                          'Usually within a few hours',
                    ),
                  if (!twoFaEnabled)
                    SimpleAccountBanner(
                      onTap: () {
                        onTwoFaBannerTap?.call();
                      },
                      color: SColorsLight().redLight,
                      header: 'Enable 2-Factor\nauthentication',
                      description:
                          'To protect your account, it is recommended '
                              'to turn on',
                    ),
                  SimpleAccountBanner(
                    onTap: () {
                      onChatBannerTap?.call();
                    },
                    color: SColorsLight().yellowLight,
                    header: 'Chat with support',
                    description: 'Have any questions?\nWe here to help 24/7',
                  ),
                  const SpaceW14(),
                ],
              ),
            ),
          if (kycPassed || phoneVerified || twoFaEnabled)
            Container(
              alignment: Alignment.center,
              height: setSizedBoxHeight(
                kycPassed: kycPassed,
                phoneVerified: phoneVerified,
                twoFaEnabled: twoFaEnabled,
              ),
              margin: const EdgeInsets.only(left: 8),
              child: SimpleAccountBanner(
                onTap: () {
                  onChatBannerTap?.call();
                },
                color: SColorsLight().yellowLight,
                header: 'Chat with support',
                description: 'Have any questions?\nWe here to help 24/7',
              ),
            ),
        ],
      ),
    );
  }

  double setSizedBoxHeight({
    required bool kycPassed,
    required bool phoneVerified,
    required bool twoFaEnabled,
  }) {
    if (!kycPassed || !phoneVerified) {
      return 171;
    } else if (!twoFaEnabled) {
      return 155;
    } else {
      return 129;
    }
  }
}
