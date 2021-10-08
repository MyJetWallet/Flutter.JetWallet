import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../shared/components/buttons/app_button_outlined.dart';
import '../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/notifiers/enter_phone_notifier/enter_phone_notipod.dart';

class SendNotifyFriend extends HookWidget {
  const SendNotifyFriend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final enterPhone = useProvider(enterPhoneNotipod);

    return PageFrame(
      leftIcon: Icons.clear,
      onBackButton: () => navigateToRouter(context.read),
      header: 'Notify your friend that you send him money.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH20(),
          Text(
            "Person with number ${enterPhone.phoneNumber} doesn't have "
            'Simple app yet.',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          AppButtonSolid(
            name: 'Send him message',
            //TODO(any): add links to app stores
            onTap: () => Share.share(
              'I have sent you some money. Please '
              'install Simple app to get them.',
            ),
          ),
          const SpaceH8(),
          AppButtonOutlined(
            name: 'Later',
            onTap: () => navigateToRouter(context.read),
          ),
        ],
      ),
    );
  }
}
