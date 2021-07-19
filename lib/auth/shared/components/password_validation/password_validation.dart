import 'package:flutter/material.dart';

import '../../../../shared/components/spacers.dart';
import '../../helpers/password_validators.dart';
import 'components/password_validation_case.dart';

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
        const SpaceH10(),
        const Text(
          'Your password must: ',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        PasswordValidationCase(
          casePassed: case1,
          description: 'be between 8 to 31 characters ',
        ),
        PasswordValidationCase(
          casePassed: case2,
          description: 'сontain at least one letter (a-z)',
        ),
        PasswordValidationCase(
          casePassed: case3,
          description: 'contain at least one number (0-9)',
        ),
        const SpaceH10(),
        if (case1 && case2 && case3)
          const PasswordValidationCase(
            finalCase: true,
            casePassed: true,
            description: 'Well Done! Your password is strong',
          ),
      ],
    );
  }
}
