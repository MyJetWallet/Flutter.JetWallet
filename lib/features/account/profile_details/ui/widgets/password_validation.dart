import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';

class PasswordValidation extends StatelessWidget {
  const PasswordValidation({
    super.key,
    required this.password,
  });

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
