import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../simple_kit.dart';

class SimpleAccountBannerList extends StatelessWidget {
  const SimpleAccountBannerList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.2.sh,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          SimpleAccountBanner(
            header: 'Verify your profile!',
            description: 'In accordance with KYC and AML Policy, '
                'you are required to pass the '
                'verification process.',
          ),
          SpaceW10(),
          SimpleAccountBanner(
            header: 'We’re verifying now',
            description: 'You’ll be notified after we’ve completed '
                'the process. Usually within a few hours',
          ),
          SpaceW10(),
          SimpleAccountBanner(
            header: 'Chat with support',
            description: 'Have any questions? We are here to help 24/7',
          ),
          SpaceW10(),
          SimpleAccountBanner(
            header: 'Enable 2-Factor authentication',
            description: 'To protect your account, it is '
                'recommended to turn on',
          ),
        ],
      ),
    );
  }
}