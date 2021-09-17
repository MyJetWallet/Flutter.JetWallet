import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../shared/components/loader.dart';
import '../../../shared/components/spacers.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/helpers/show_plain_snackbar.dart';
import '../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../shared/notifiers/logout_notifier/logout_union.dart';
import '../../../shared/providers/service_providers.dart';
import 'account_security/account_security.dart';

class Account extends HookWidget {
  const Account();

  @override
  Widget build(BuildContext context) {
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);
    final intl = useProvider(intlPod);
    final authInfo = useProvider(authInfoNotipod);

    return ProviderListener<LogoutUnion>(
      provider: logoutNotipod,
      onChange: (context, union) {
        union.when(
          result: (error, st) {
            if (error != null) {
              showPlainSnackbar(context, '$error');
            }
          },
          loading: () {},
        );
      },
      child: logout.when(
        result: (_, __) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    final auth = LocalAuthentication();

                    final availableBiometrics =
                        await auth.getAvailableBiometrics();

                    print(availableBiometrics);

                    if (Platform.isIOS) {
                      if (availableBiometrics.contains(BiometricType.face)) {
                        // Face ID.
                      } else if (availableBiometrics
                          .contains(BiometricType.fingerprint)) {
                        // Touch ID.
                      }
                    } else if (Platform.isAndroid) {
                      final result = await auth.authenticate(
                        localizedReason: 'We need you to confirm your identity',
                        stickyAuth: true,
                        biometricOnly: true,
                      );

                      print(result);
                    }
                  },
                  child: const Text(
                    'FACE ID',
                  ),
                ),
                Text(
                  intl.account,
                ),
                const SpaceH10(),
                Text(
                  authInfo.email,
                ),
                const SpaceH10(),
                TextButton(
                  onPressed: () {
                    navigatorPush(context, const AccountSecurity());
                  },
                  child: const Text(
                    'Security',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    logoutN.logout();
                  },
                  child: Text(intl.logout),
                ),
              ],
            ),
          );
        },
        loading: () => const Loader(),
      ),
    );
  }
}
