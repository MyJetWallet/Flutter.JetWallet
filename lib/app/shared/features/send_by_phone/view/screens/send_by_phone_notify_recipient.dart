import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';

class SendByPhoneNotifyRecipient extends HookWidget {
  const SendByPhoneNotifyRecipient({
    Key? key,
    required this.toPhoneNumber,
  }) : super(key: key);

  final String toPhoneNumber;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SPageFrameWithPadding(
      header: const SMegaHeader(
        titleAlign: TextAlign.start,
        title: 'Notify the recipient about sent',
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
            'This phone number is not linked to Simple account.',
            maxLines: 4,
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
          ),
          const SpaceH24(),
          Text(
            'Send a message how to receive funds.',
            maxLines: 4,
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
          ),
          const Spacer(),
          SPrimaryButton2(
            active: true,
            name: 'Send a message',
            onTap: () {
              Share.share(
                'I have sent you some money to $toPhoneNumber. Please '
                'install Simple app to get them.',
              );
            },
          ),
          const SpaceH10(),
          STextButton1(
            active: true,
            name: 'Later',
            onTap: () => Navigator.pop(context),
          ),
          const SpaceH24()
        ],
      ),
    );
  }
}
