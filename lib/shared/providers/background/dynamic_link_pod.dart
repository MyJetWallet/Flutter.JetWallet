import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/screens/email_verification/view/email_verification.dart';
import '../../../auth/screens/reset_password/view/reset_password.dart';
import '../../../service_providers.dart';
import '../other/navigator_key_pod.dart';

const _token = 'jw_token';
const _command = 'jw_command';
const _emailVerification = 'emailverification';
const _forgotPassword = 'ForgotPassword';

final dynamicLinkPod = Provider<void>(
  (ref) {
    final service = ref.watch(dynamicLinkServicePod);
    final navigatorKey = ref.watch(navigatorKeyPod);

    service.initDynamicLinks(
      handler: (link) {
        final parameters = link.queryParameters;

        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              if (parameters[_command] == _emailVerification) {
                return const EmailVerification();
              } else if (parameters[_command] == _forgotPassword) {
                return ResetPassword(
                  token: parameters[_token],
                );
              } else {
                return _UndefinedDeepLink(
                  deepLinkParameters: parameters,
                );
              }
            },
          ),
          (route) => route.isFirst == true,
        );
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
