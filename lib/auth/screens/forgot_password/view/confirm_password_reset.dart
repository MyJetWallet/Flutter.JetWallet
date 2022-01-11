import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/get_args.dart';
import '../../../../shared/helpers/open_email_app.dart';

@immutable
class ConfirmPasswordResetArgs {
  const ConfirmPasswordResetArgs({
    required this.email,
  });

  final String email;
}

class ConfirmPasswordReset extends HookWidget {
  const ConfirmPasswordReset({Key? key}) : super(key: key);

  static const routeName = '/confirm_password_reset';

  static Future push({
    required BuildContext context,
    required ConfirmPasswordResetArgs args,
  }) {
    return Navigator.pushNamed(
      context,
      routeName,
      arguments: args,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = getArgs(context) as ConfirmPasswordResetArgs;

    final colors = useProvider(sColorPod);

    return SPageFrameWithPadding(
      header: const SBigHeader(
        title: 'Check your Email',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH7(),
          Text(
            'Recovery email with reset password instruction has been '
            'sent to',
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
            maxLines: 2,
          ),
          Text(
            '${args.email} \n',
            style: sBodyText1Style,
            maxLines: 2,
          ),
          Text(
            "If you don't see the password recovery email in your inbox, "
            'check your spam folder',
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
            maxLines: 2,
          ),
          const SpaceH17(),
          SClickableLinkText(
            text: 'Open Email App',
            onTap: () => openEmailApp(context),
          ),
        ],
      ),
    );
  }
}
