import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'credentials_state.dart';

class CredentialsNotifier extends StateNotifier<CredentialsState> {
  CredentialsNotifier()
      : super(
          CredentialsState(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            repeatPasswordController: TextEditingController(),
          ),
        );

  void clear() {
    state = CredentialsState(
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      repeatPasswordController: TextEditingController(),
    );
  }
}
