import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/screens/email_verification/provider/email_verification_notipod.dart';
import '../../../auth/screens/reset_password/view/reset_password.dart';
import '../../../router/provider/authorized_stpod/authorized_stpod.dart';
import '../../../router/provider/authorized_stpod/authorized_union.dart';
import '../../helpers/push_and_remove_until.dart';
import '../other/navigator_key_pod.dart';
import '../service_providers.dart';

const _code = 'jw_code';
const _token = 'jw_token';
const _command = 'jw_command';
const _confirmEmail = 'ConfirmEmail';
const _forgotPassword = 'ForgotPassword';

final dynamicLinkPod = Provider<void>(
  (ref) {
    final service = ref.watch(dynamicLinkServicePod);
    final navigatorKey = ref.watch(navigatorKeyPod);
    final authorized = ref.watch(authorizedStpod);

    service.initDynamicLinks(
      handler: (link) {
        final parameters = link.queryParameters;

        if (parameters[_command] == _confirmEmail) {
          if (authorized.state is EmailVerification) {
            final notifier = ref.read(emailVerificationNotipod.notifier);

            notifier.updateController(parameters[_code]);
          }
        } else if (parameters[_command] == _forgotPassword) {
          pushAndRemoveUntil(
            navigatorKey: navigatorKey,
            page: ResetPassword(
              token: parameters[_token],
            ),
          );
        } else {
          pushAndRemoveUntil(
            navigatorKey: navigatorKey,
            page: _UndefinedDeepLink(
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
