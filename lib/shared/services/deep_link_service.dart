import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../app/shared/features/currency_withdraw/provider/withdraw_dynamic_link_stpod.dart';
import '../../auth/screens/email_verification/notifier/email_verification_notipod.dart';
import '../../auth/screens/email_verification/view/email_verification.dart';
import '../../auth/screens/login/login.dart';
import '../../auth/screens/reset_password/view/reset_password.dart';
import '../../router/notifier/startup_notifier/startup_state.dart';
import '../helpers/navigator_push.dart';
import '../notifiers/logout_notifier/logout_notipod.dart';
import '../notifiers/user_info_notifier/user_info_notipod.dart';

const _code = 'jw_code';
const _token = 'jw_token';
const _command = 'jw_command';
const _confirmEmail = 'ConfirmEmail';
const _forgotPassword = 'ForgotPassword';
const _login = 'Login';
const _confirmWithdraw = 'jw_withdrawal_email_confirm';
const _confirmSend = 'jw_transfer_email_confirm';
const _operationId = 'jw_operation_id';
const _jwCommand = 'InviteFriend';

class DeepLinkService {
  DeepLinkService({
    required this.read,
    required this.navigatorKey,
    required this.startup,
  });

  final Reader read;
  final GlobalKey navigatorKey;
  final StartupState startup;

  void handle(Uri link) {
    final parameters = link.queryParameters;
    final command = parameters[_command];

    switch (command) {
      case _confirmEmail:
        if (startup.authorized is EmailVerification) {
          final notifier = read(emailVerificationNotipod.notifier);
          notifier.updateCode(parameters[_code]);
        }
        break;
      case _login:
        {
          read(logoutNotipod.notifier).logout();
          navigatorPush(navigatorKey.currentContext!, const Login());
        }
        break;
      case _forgotPassword:
        navigatorPush(
          navigatorKey.currentContext!,
          ResetPassword(
            token: parameters[_token]!,
          ),
        );
        break;
      case _confirmWithdraw:
        final id = parameters[_operationId]!;
        read(withdrawDynamicLinkStpod(id)).state = true;
        break;
      case _confirmSend:
        final id = parameters[_operationId]!;
        read(withdrawDynamicLinkStpod(id)).state = true;
        break;
      case _jwCommand:
        {
          final userInfo = read(userInfoNotipod);

          sShowBasicModalBottomSheet(
            context: navigatorKey.currentContext!,
            removeBottomHeaderPadding: true,
            removeBottomSheetBar: true,
            removeTopHeaderPadding: true,
            horizontalPinnedPadding: 0,
            scrollable: true,
            pinned: const SReferralInvitePinned(),
            children: [
              SReferralInviteBody(
                primaryText: 'Invite friends and get \$10',
                qrCodeLink: userInfo.referralLink,
                referralLink: userInfo.referralLink,
              ),
            ],
          );
        }
        break;
      default:
        navigatorPush(
          navigatorKey.currentContext!,
          _UndefinedDeepLink(
            deepLinkParameters: parameters,
          ),
        );
    }
  }
}

class _UndefinedDeepLink extends StatelessWidget {
  const _UndefinedDeepLink({
    Key? key,
    required this.deepLinkParameters,
  }) : super(key: key);

  final Map<String, String> deepLinkParameters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Undefined Deep Link',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            for (final parameter in deepLinkParameters.entries)
              Text('${parameter.key}: ${parameter.value}')
          ],
        ),
      ),
    );
  }
}
