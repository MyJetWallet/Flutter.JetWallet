import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../helpers/password_validators.dart';

class PasswordValidation extends StatelessWidget {
  const PasswordValidation({
    Key? key,
    required this.password,
  }) : super(key: key);

  final String password;

  @override
  Widget build(BuildContext context) {
    final case1 = isPasswordLengthValid(password);
    final case2 = isPasswordHasAtLeastOneLetter(password);
    final case3 = isPasswordHasAtLeastOneNumber(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH24(),
        SRequirement(
          passed: case1,
          description: 'be between 8 to 31 characters',
        ),
        SRequirement(
          passed: case2,
          description: 'сontain at least one letter (a-z)',
        ),
        SRequirement(
          passed: case3,
          description: 'contain at least one number (0-9)',
        ),
      ],
    );
  }
}
