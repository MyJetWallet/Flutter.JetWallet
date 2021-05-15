import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/loader.dart';
import '../../../../shared/components/spacers.dart';
import '../notifiers/logout_notifier/union/logout_union.dart';
import '../providers/logout_notipod.dart';

class Profile extends HookWidget {
  const Profile();

  @override
  Widget build(BuildContext context) {
    final state = useProvider(logoutNotipod);
    final notifier = useProvider(logoutNotipod.notifier);

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
                const Text(
                  'Profile',
                ),
                SpaceH15(),
                TextButton(
                  onPressed: () {
                    notifier.logout();
                  },
                  child: const Text('Logout'),
                )
              ],
            ),
          );
        },
        loading: () => Loader(),
      ),
    );
  }
}
