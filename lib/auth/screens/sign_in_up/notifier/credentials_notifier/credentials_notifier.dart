import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
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

  static final _logger = Logger('CredentialsNotifier');

  void clear() {
    _logger.log(notifier, 'clear');
    
    state = CredentialsState(
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      repeatPasswordController: TextEditingController(),
    );
  }
}
