import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../simple_kit.dart';

class SimpleAccountBannerList extends StatelessWidget {
  const SimpleAccountBannerList({
    Key? key,
    this.onTwoFaBannerTap,
    this.onChatBannerTap,
    required this.colors,
    required this.twoFaEnabled,
    required this.kycPassed,
    required this.phoneVerified,
  }) : super(key: key);

  final SimpleColors colors;
  final bool twoFaEnabled;
  final bool kycPassed;
  final bool phoneVerified;
  final Function()? onTwoFaBannerTap;
  final Function()? onChatBannerTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: setSizedBoxHeight(
        kycPassed: kycPassed,
        phoneVerified: phoneVerified,
        twoFaEnabled: twoFaEnabled,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SpaceW24(),
          if (kycPassed)
            SimpleAccountBanner(
              onTap: () {},
              bannerColor: colors.violet,
              header: 'Verify your profile',
              description: 'In accordance with KYC and AML Policy, '
                  'you are required to pass the '
                  'verification process.',
            ),
          if (phoneVerified)
            SimpleAccountBanner(
              onTap: () {},
              bannerColor: colors.greenLight,
              header: 'Verifying now',
              description:
                  'You’ll be notified after we’ve completed the process. '
                  'Usually within a few hours',
            ),
          if (twoFaEnabled)
            SimpleAccountBanner(
              onTap: () {
                onTwoFaBannerTap?.call();
              },
              bannerColor: colors.redLight,
              header: 'Enable 2-Factor\nauthentication',
              description:
                  'To protect your account, it is recommended to turn on',
            ),
          SimpleAccountBanner(
            onTap: () {
              onChatBannerTap?.call();
            },
            bannerColor: colors.yellowLight,
            header: 'Chat with support',
            description: 'Have any questions?\nWe here to help 24/7',
          ),
          const SpaceW14(),
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
      return 0.22.sh;
    } else if (!twoFaEnabled) {
      return 0.18.sh;
    } else {
      return 0.22.sh;
    }
  }
}
