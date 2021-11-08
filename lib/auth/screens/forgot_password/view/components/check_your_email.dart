import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/open_email_app.dart';
import '../../../../shared/components/clickable_link_text/clickable_link_text.dart';

class CheckYourEmail extends HookWidget {
  const CheckYourEmail(this.email);

  final String email;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SPageFrameWithPadding(
      header: SBigHeader(
        title: 'Check your Email',
        onBackButtonTap: () => Navigator.pop(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH7(),
          Text(
            'Recovery email with reset password instruction has been '
            'sent to',
            style: sBodyText1Style.copyWith(color: colors.grey1),
            maxLines: 2,
          ),
          Text(
            '$email \n',
            style: sBodyText1Style,
            maxLines: 2,
          ),
          Text(
            'If you don’t see the password recovery email in your inbox, '
            'check your spam folder',
            style: sBodyText1Style.copyWith(color: colors.grey1),
            maxLines: 2,
          ),
          const SpaceH17(),
          ClickableLinkText(
            text: 'Open Email App',
            onTap: () => openEmailApp(context),
          ),
        ],
      ),
    );
  }
}
