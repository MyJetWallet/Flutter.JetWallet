import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../../../shared/providers/service_providers.dart';

class SendByPhoneNotifyRecipient extends HookWidget {
  const SendByPhoneNotifyRecipient({
    Key? key,
    required this.toPhoneNumber,
  }) : super(key: key);

  final String toPhoneNumber;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final userInfo = useProvider(userInfoNotipod);
    final canTapShare = useState(true);

    return SPageFrameWithPadding(
      header: SMegaHeader(
        titleAlign: TextAlign.start,
        title: intl.sendByPhoneRecipient_headerTitle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH4(),
          Text(
            toPhoneNumber,
            style: sBodyText1Style,
          ),
          Text(
            '${intl.sendByPhoneRecipient_text1}.',
            maxLines: 4,
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
          ),
          const SpaceH24(),
          Text(
            '${intl.sendByPhoneRecipient_text2}.',
            maxLines: 4,
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
          ),
          const Spacer(),
          SPrimaryButton2(
            active: true,
            name: intl.sendAMessage,
            onTap: () {
              if (canTapShare.value) {
                canTapShare.value = false;
                Timer(
                  const Duration(seconds: 1),
                  () => canTapShare.value = true,
                );
                Share.share(
                  '${intl.sendByPhoneRecipient_text3} $toPhoneNumber. '
                      '${intl.sendByPhoneRecipient_text4}.\n '
                      '${userInfo.referralLink}',
                );
              }
            },
          ),
          const SpaceH10(),
          STextButton1(
            active: true,
            name: intl.later,
            onTap: () => Navigator.pop(context),
          ),
          const SpaceH24()
        ],
      ),
    );
  }
}
