import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/screens/market/view/market.dart';
import 'package:jetwallet/app/shared/features/about_us/view/about_us.dart';
import 'package:jetwallet/router/view/router.dart';
import 'package:jetwallet/shared/features/two_fa/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import 'package:jetwallet/shared/notifiers/user_info_notifier/user_info_notipod.dart';
import 'package:jetwallet/shared/services/deep_link_service.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../app/shared/features/currency_withdraw/provider/withdraw_dynamic_link_stpod.dart';
import '../../../auth/screens/email_verification/notifier/email_verification_notipod.dart';
import '../../../auth/screens/email_verification/view/email_verification.dart';
import '../../../auth/screens/login/login.dart';
import '../../../auth/screens/reset_password/view/reset_password.dart';
import '../../../router/notifier/startup_notifier/startup_notipod.dart';
import '../../helpers/navigator_push.dart';
import '../../notifiers/logout_notifier/logout_notipod.dart';
import '../service_providers.dart';

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
const _jwCommandRedirect = 'ReferralRedirect';

final dynamicLinkPod = Provider<void>(
  (ref) {
    final service = ref.watch(dynamicLinkServicePod);
    final navigatorKey = ref.watch(sNavigatorKeyPod);
    final startup = ref.watch(startupNotipod);

    service.initDynamicLinks(
      handler: (link) {
        final parameters = link.queryParameters;
        final command = parameters[_command];

        if (command == _confirmEmail) {
          if (startup.authorized is EmailVerification) {
            final notifier = ref.read(emailVerificationNotipod.notifier);

            notifier.updateCode(parameters[_code]);
          }
        } else if (command == _login) {
          ref.read(logoutNotipod.notifier).logout();

          navigatorPush(navigatorKey.currentContext!, const Login());
        } else if (command == _forgotPassword) {
          navigatorPush(
            navigatorKey.currentContext!,
            ResetPassword(
              token: parameters[_token]!,
            ),
          );
        } else if (command == _confirmWithdraw || command == _confirmSend) {
          final id = parameters[_operationId]!;
          ref.read(withdrawDynamicLinkStpod(id)).state = true;
        } else if (command == _jwCommand) {
          final userInfo = ref.read(userInfoNotipod);
          DeepLinkService().showBasicModalBottomSheet(
            navigatorKey.currentContext!,
            userInfo.referralLink!,
            userInfo.referralCode!,
          );
        } else {
          navigatorPush(
            navigatorKey.currentContext!,
            _UndefinedDeepLink(
              deepLinkParameters: parameters,
            ),
          );
        }
      },
    );
  },
  name: 'dynamicLinkPod',
);

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
