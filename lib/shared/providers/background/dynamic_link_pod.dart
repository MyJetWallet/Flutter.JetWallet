import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../auth/screens/reset_password/view/reset_password.dart';

import '../../../service_providers.dart';
import '../other/navigator_key_pod.dart';

const command = 'jw_command';
const emailVerification = 'emailverification';
const forgotPassword = 'ForgotPassword';
const token = 'jw_token';

final dynamicLinkPod = Provider<void>(
  (ref) {
    final service = ref.watch(dynamicLinkServicePod);
    final navigatorKey = ref.watch(navigatorKeyPod);

    service.initDynamicLinks(
      handler: (link) {
        final parameters = link.queryParameters;

        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) {
              if (parameters[command] == emailVerification) {
                return EmailVerification(
                  deepLinkParameters: parameters,
                );
              } else if (parameters[command] == forgotPassword) {
                return ResetPassword(
                  token: parameters[token],
                );
              } else {
                return UndefinedDeepLink(
                  deepLinkParameters: parameters,
                );
              }
            },
          ),
        );
      },
    );
  },
  name: 'dynamicLinkPod',
);

// TODO: Refactor, we need to review our current arch of the app
class EmailVerification extends StatelessWidget {
  const EmailVerification({
    Key? key,
    required this.deepLinkParameters,
  }) : super(key: key);

  final Map<String, String> deepLinkParameters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Email Verification',
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

// TODO: Refactor, we need to review our current arch of the app
class UndefinedDeepLink extends StatelessWidget {
  const UndefinedDeepLink({
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
