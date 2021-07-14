import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/screens/sign_in_up/notifier/auth_model_notifier/auth_model_notipod.dart';
import '../../../shared/components/loader.dart';
import '../../../shared/components/spacers.dart';
import '../../../shared/helpers/show_plain_snackbar.dart';
import '../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../shared/notifiers/logout_notifier/logout_union.dart';
import '../../../shared/providers/service_providers.dart';

class Account extends HookWidget {
  const Account();

  @override
  Widget build(BuildContext context) {
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);
    final intl = useProvider(intlPod);
    final authModel = useProvider(authModelNotipod);

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
                Text(
                  intl.account,
                ),
                const SpaceH10(),
                Text(
                  authModel.email,
                ),
                const SpaceH10(),
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
        loading: () => Loader(),
      ),
    );
  }
}
