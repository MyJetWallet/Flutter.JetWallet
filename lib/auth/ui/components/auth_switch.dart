import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../service_providers.dart';
import '../../providers/auth_screen_stpod.dart';
import '../../providers/credentials_notipod.dart';

class AuthSwitch extends HookWidget {
  const AuthSwitch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authScreen = useProvider(authScreenStpod);
    final notifier = useProvider(credentialsNotipod.notifier);
    final intl = useProvider(intlPod);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (authScreen.state == AuthScreen.signIn) {
          authScreen.state = AuthScreen.signUp;
          notifier.clear();
        } else {
          authScreen.state = AuthScreen.signIn;
          notifier.clear();
        }
      },
      child: Text(
        authScreen.state == AuthScreen.signIn
            ? '${intl!.dontHaveAnAccount} ${intl.signUp}'
            : '${intl!.haveAnAccount} ${intl.signIn}',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
