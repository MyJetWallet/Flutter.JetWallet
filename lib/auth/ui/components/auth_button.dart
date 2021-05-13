import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../state/providers/auth_screen_stpod.dart';
import '../../state/providers/authentication_notipod.dart';

class AuthButton extends HookWidget {
  const AuthButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authScreen = useProvider(authScreenStpod);
    final notifier = useProvider(authenticationNotipod.notifier);

    return Center(
      child: InkWell(
        onTap: () => notifier.authenticate(authScreen.state),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 100.0,
            vertical: 15.0,
          ),
          decoration: BoxDecoration(
            color: Colors.pink[400],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            authScreen.state == AuthScreen.signIn ? 'Sign In' : 'Sign Up',
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
