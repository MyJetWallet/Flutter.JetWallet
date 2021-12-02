import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../simple_kit.dart';

class SimpleAccountBannerList extends StatelessWidget {
  const SimpleAccountBannerList({
    Key? key,
    required this.colors,
    required this.twoFaEnabled,
    required this.kycPassed,
  }) : super(key: key);

  final SimpleColors colors;
  final bool twoFaEnabled;
  final bool kycPassed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.22.sh,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SpaceW24(),
          if (kycPassed)
          SimpleAccountBanner(
            bannerColor: colors.violet,
            header: 'Verify your profile',
            description: 'In accordance with KYC and AML Policy, '
                'you are required to pass the '
                'verification process.',
          ),

          SimpleAccountBanner(
            bannerColor: colors.greenLight,
            header: 'Verifying now',
            description:
                'You’ll be notified after we’ve completed the process. '
                'Usually within a few hours',
          ),
          if (twoFaEnabled)
            SimpleAccountBanner(
              bannerColor: colors.redLight,
              header: 'Enable 2-Factor\nauthentication',
              description:
                  'To protect your account, it is recommended to turn on',
            ),

          SimpleAccountBanner(
            bannerColor: colors.yellowLight,
            header: 'Chat with support',
            description: 'Have any questions?\nWe here to help 24/7',
          ),
          const SpaceW14(),
        ],
      ),
    );
  }
}
