import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../auth/provider/auth_model_notipod.dart';

import '../../../../service_providers.dart';
import '../../../../shared/components/loader.dart';
import '../../../../shared/components/spacers.dart';
import '../notifier/logout_union.dart';
import '../provider/logout_notipod.dart';

class Profile extends HookWidget {
  const Profile();

  @override
  Widget build(BuildContext context) {
    final state = useProvider(logoutNotipod);
    final notifier = useProvider(logoutNotipod.notifier);
    final intl = useProvider(intlPod);
    final authModel = useProvider(authModelNotipod);

    return ProviderListener<LogoutUnion>(
      provider: logoutNotipod,
      onChange: (context, union) {
        union.when(
          result: (e, st) {
            if (e != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          },
          loading: () {},
        );
      },
      child: state.when(
        result: (_, __) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  intl.profile,
                ),
                const SpaceH15(),
                Text(
                  authModel.email,
                ),
                const SpaceH15(),
                TextButton(
                  onPressed: () {
                    notifier.logout();
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
