import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/providers/service_providers.dart';
import '../../helpers/password_validators.dart';

class PasswordValidation extends HookWidget {
  const PasswordValidation({
    Key? key,
    required this.password,
  }) : super(key: key);

  final String password;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final case1 = isPasswordLengthValid(password);
    final case2 = isPasswordHasAtLeastOneLetter(password);
    final case3 = isPasswordHasAtLeastOneNumber(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH24(),
        SRequirement(
          passed: case1,
          description: intl.passwordValidation_text1,
        ),
        SRequirement(
          passed: case2,
          description: intl.passwordValidation_text2,
        ),
        SRequirement(
          passed: case3,
          description: intl.passwordValidation_text3,
        ),
      ],
    );
  }
}
