import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'SendByPhoneNotifyRecipientRouter')
class SendByPhoneNotifyRecipient extends StatefulObserverWidget {
  const SendByPhoneNotifyRecipient({
    Key? key,
    required this.toPhoneNumber,
  }) : super(key: key);

  final String toPhoneNumber;

  @override
  State<SendByPhoneNotifyRecipient> createState() =>
      _SendByPhoneNotifyRecipientState();
}

class _SendByPhoneNotifyRecipientState
    extends State<SendByPhoneNotifyRecipient> {
  bool canTapShare = true;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final userInfo = sUserInfo.userInfo;

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      header: SMegaHeader(
        titleAlign: TextAlign.start,
        title: intl.sendByPhoneRecipient_headerTitle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH4(),
          Text(
            widget.toPhoneNumber,
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
            name: intl.sendByPhoneNotifyRecipient_sendAMessage,
            onTap: () {
              if (canTapShare) {
                setState(() {
                  canTapShare = false;
                });

                Timer(
                  const Duration(seconds: 1),
                  () => setState(() {
                    canTapShare = true;
                  }),
                );

                try {
                  Share.share(
                    '${intl.sendByPhoneRecipient_text3} ${widget.toPhoneNumber.replaceAll(" ", "")}. '
                    '${intl.sendByPhoneRecipient_text4}.\n '
                    '${userInfo.referralLink}',
                  );
                  Navigator.pop(context);
                } catch (e) {}
              }
            },
          ),
          const SpaceH10(),
          STextButton1(
            active: true,
            name: intl.sendByPhoneRecipient_later,
            onTap: () => {
              Navigator.pop(context),
            },
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
